#!/usr/bin/env bash
# provision_users_and_dirs.sh
# ----------------------------------------------------------------------
# Description:
# This script automates the creation and configuration of users, groups,
# directories, and permissions in a Linux environment. It is designed to
# prepare new virtual machines for immediate use by provisioning the
# complete user infrastructure in a single execution. The script supports
# dry-run testing, detailed logging, and secure password generation.
# ----------------------------------------------------------------------
# Usage:
# sudo ./provision_users_and_dirs.sh --apply --users users.csv --dirs directories.csv --groups groups.txt
# sudo ./provision_users_and_dirs.sh --dry-run --users users.csv --dirs directories.csv --groups groups.txt
# ----------------------------------------------------------------------


# (The rest of the script content remains unchanged below...)

set -euo pipefail
IFS=$'\n\t'

LOGFILE="/var/log/provision_users.log"
REPORT="/root/provision_report_$(date +%Y%m%d_%H%M%S).txt"
DRY_RUN=true
USERS_CSV="users.csv"
DIRS_CSV="directories.csv"
GROUPS_TXT="groups.txt"
KEEP_PASSWD=false
FORCE_UID=false
USE_SETFACL=false

function log() {
  local msg="$1"
  echo "$(date '+%F %T') $msg" | tee -a "$LOGFILE"
}

function usage() {
  cat <<EOF
Usage: sudo $0 [--apply] [--users users.csv] [--dirs directories.csv] [--groups groups.txt] [--no-setfacl]

Options:
  --apply            Run changes (default: dry run). Use to actually apply changes.
  --users FILE       CSV: username,uid,primary_group,secondary_groups,home,shell,sudo,ssh_pubkey_path
  --dirs FILE        CSV: path,owner,group,mode,acl (acl optional)
  --groups FILE      Plain text file with one group name per line.
  --keep-passwd      Do not remove generated passwords (will echo in report). Use carefully.
  --force-uid        Allow specifying UID values in users.csv and create with that UID.
  --no-setfacl       Do not attempt to set ACLs (setfacl must be installed if used).
  -h, --help         Show this help.

Example users.csv line:
  alice,,developers,gitops, /home/alice,/bin/bash,yes,/tmp/alice.pub
  Fields: username,uid(empty for auto),primary_group,secondary_groups(comma separated),home,shell,sudo(yes/no),ssh_pubkey_path(empty allowed)

Example dirs.csv line:
  /srv/project,alice,developers,750,default:user:alice:rwx

EOF
}

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply) DRY_RUN=false; shift;;
    --users) USERS_CSV="$2"; shift 2;;
    --dirs) DIRS_CSV="$2"; shift 2;;
    --groups) GROUPS_TXT="$2"; shift 2;;
    --keep-passwd) KEEP_PASSWD=true; shift;;
    --force-uid) FORCE_UID=true; shift;;
    --no-setfacl) USE_SETFACL=false; shift;;
    -h|--help) usage; exit 0;;
    *) echo "Unknown arg: $1"; usage; exit 1;;
  esac
done

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root. Exiting." >&2
  exit 2
fi

mkdir -p "$(dirname "$LOGFILE")"
log "Starting provisioning script. Dry run: $DRY_RUN"

# Helper to run or echo
function run() {
  if [[ "$DRY_RUN" == true ]]; then
    echo "DRY-RUN: $*"
  else
    log "RUN: $*"
    eval "$@"
  fi
}

# Create groups
if [[ -f "$GROUPS_TXT" ]]; then
  log "Processing groups from $GROUPS_TXT"
  while IFS= read -r grp || [[ -n "$grp" ]]; do
    grp_trim=$(echo "$grp" | awk '{gsub(/^ +| +$/,"",$0); print $0}')
    [[ -z "$grp_trim" ]] && continue
    if getent group "$grp_trim" >/dev/null; then
      log "Group $grp_trim exists. Skipping."
    else
      run "groupadd --force '$grp_trim'"
      log "Group created: $grp_trim"
    fi
  done < "$GROUPS_TXT"
else
  log "Groups file $GROUPS_TXT not found. Skipping group creation."
fi

# Process users CSV
if [[ -f "$USERS_CSV" ]]; then
  log "Processing users from $USERS_CSV"
  echo "Provision report - $(date)" > "$REPORT"
  echo "" >> "$REPORT"
  while IFS=, read -r username uid primary secondary home shell sudo_flag ssh_pub; do
    # Trim spaces
    username=$(echo "$username" | xargs)
    [[ -z "$username" ]] && continue
    uid=$(echo "$uid" | xargs)
    primary=$(echo "$primary" | xargs)
    secondary=$(echo "$secondary" | xargs)
    home=$(echo "$home" | xargs)
    shell=$(echo "$shell" | xargs)
    sudo_flag=$(echo "$sudo_flag" | xargs)
    ssh_pub=$(echo "$ssh_pub" | xargs)

    log "Handling user: $username"

    # Create primary group if missing
    if [[ -n "$primary" ]] && ! getent group "$primary" >/dev/null; then
      run "groupadd --force '$primary'"
      log "Primary group created: $primary"
    fi

    # Build useradd options
    opts=( )
    [[ -n "$home" ]] && opts+=( -d "${home}" -m ) || opts+=( -m )
    [[ -n "$shell" ]] && opts+=( -s "$shell" )
    if [[ -n "$uid" ]]; then
      if [[ "$FORCE_UID" == true ]]; then
        opts+=( -u "$uid" )
      else
        log "UID provided but --force-uid not used. Ignoring UID for $username"
      fi
    fi
    [[ -n "$primary" ]] && opts+=( -g "$primary" )
    if [[ -n "$secondary" ]]; then
      # remove spaces
      sec_clean=$(echo "$secondary" | sed 's/ //g')
      opts+=( -G "$sec_clean" )
    fi

    if id -u "$username" >/dev/null 2>&1; then
      log "User $username exists. Ensuring home, groups and shell are correct."
      # modify user
      modcmd=( usermod )
      [[ -n "$home" ]] && modcmd+=( -d "$home" -m )
      [[ -n "$shell" ]] && modcmd+=( -s "$shell" )
      [[ -n "$primary" ]] && modcmd+=( -g "$primary" )
      [[ -n "$secondary" ]] && modcmd+=( -G "$sec_clean" )
      run "${modcmd[*]} $username"
    else
      # Create user
      run "useradd ${opts[*]} '$username'"
      log "User created: $username"
    fi

    # Generate a random password
    PASS=$(openssl rand -base64 12)
    ENC_PASS=$(openssl passwd -6 "$PASS")
    if [[ "$DRY_RUN" == false ]]; then
      usermod -p "$ENC_PASS" "$username" || true
    else
      echo "DRY-RUN would set password for $username"
    fi

    # SSH key
    if [[ -n "$ssh_pub" ]] && [[ -f "$ssh_pub" ]]; then
      AUTH_DIR="${home:-/home/$username}/.ssh"
      run "mkdir -p '$AUTH_DIR' && chown $username:$primary '$AUTH_DIR' && chmod 700 '$AUTH_DIR'"
      run "cat '$ssh_pub' >> '$AUTH_DIR/authorized_keys' && chown $username:$primary '$AUTH_DIR/authorized_keys' && chmod 600 '$AUTH_DIR/authorized_keys'"
      log "SSH key installed for $username from $ssh_pub"
    fi

    # sudo
    if [[ "$sudo_flag" == "yes" || "$sudo_flag" == "y" ]]; then
      if [[ -f /etc/sudoers.d/90-$username ]]; then
        log "Sudoers file exists for $username. Skipping."
      else
        run "echo '$username ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/90-$username && chmod 440 /etc/sudoers.d/90-$username"
        log "Sudo grant added for $username"
      fi
    fi

    # Append to report
    if [[ "$KEEP_PASSWD" == true || "$DRY_RUN" == true ]]; then
      echo "User: $username | Password: $PASS | Home: ${home:-/home/$username}" >> "$REPORT"
    else
      echo "User: $username | Password: (generated, not stored) | Home: ${home:-/home/$username}" >> "$REPORT"
    fi

  done < "$USERS_CSV"
  log "Users processing finished. Report saved to $REPORT"
else
  log "Users CSV $USERS_CSV not found. Skipping users."
fi

# Process directories CSV
if [[ -f "$DIRS_CSV" ]]; then
  log "Processing directories from $DIRS_CSV"
  while IFS=, read -r path owner group mode acl_rule; do
    path=$(echo "$path" | xargs)
    [[ -z "$path" ]] && continue
    owner=$(echo "$owner" | xargs)
    group=$(echo "$group" | xargs)
    mode=$(echo "$mode" | xargs)
    acl_rule=$(echo "$acl_rule" | xargs)

    log "Creating directory: $path"
    run "mkdir -p '$path'"
    if [[ -n "$owner" ]]; then
      run "chown '$owner':'$group' '$path'"
    fi
    if [[ -n "$mode" ]]; then
      run "chmod '$mode' '$path'"
    fi
    if [[ -n "$acl_rule" && "$USE_SETFACL" == true ]]; then
      # acl_rule example: default:user:alice:rwx
      run "setfacl -m '$acl_rule' '$path' || true"
      log "ACL set on $path: $acl_rule"
    fi
  done < "$DIRS_CSV"
else
  log "Dirs CSV $DIRS_CSV not found. Skipping directories."
fi

log "Provisioning complete. Report: $REPORT"
if [[ "$DRY_RUN" == true ]]; then
  echo "Dry run finished. Re-run with --apply to apply changes."
else
  echo "Done. Report at: $REPORT"
fi

exit 0

# --- End script ---

# Sample files (put next to the script):
# groups.txt
# developers
# gitops
# admin

# users.csv (no header, comma-separated):
# alice,,developers,gitops,/home/alice,/bin/bash,yes,/tmp/alice.pub
# bob,1501,developers,,/home/bob,/bin/bash,no,

# directories.csv (no header):
# /srv/project,alice,developers,750,
# /var/www/project,bob,developers,750,default:user:alice:rwx

# Notes:
# - Script aims to be idempotent: existing groups/users are detected and adjusted.
# - For ACLs, install setfacl (from acl package) and run with --no-setfacl omitted.
# - Keep the CSVs and groups file in a secure location before running.
# - Consider storing SSH public keys securely and mapping them in the users.csv.
# - You can upload this script to GitHub. Make sure to not commit sensitive files (private keys, plain passwords).
