# Lab Guide — Safe Setup (VM recommended)

## Purpose
Run the demo safely in an isolated environment and learn how phishing can appear. Never use real credentials.

## Requirements
- A snapshot-capable VM: VirtualBox or VMware.
- Browser inside the VM (Firefox or Chrome).
- This repository cloned inside the VM or shared folder.

## Steps (recommended)
1. Create a new VM or use an existing VM image.
2. Take a snapshot before you start (so you can revert).
3. Disable the VM network or set the adapter to "Host-only" with no internet access.
4. Copy this repo or the `demo/index.html` to the VM.
5. Open the VM browser and open the `demo/index.html` file directly (File → Open File).
6. Test the demo. Enter dummy values only.
7. Read `analysis/phishing-explained.md` and `analysis/detection-and-defense.md` to learn detection methods.
8. When finished, revert the VM to the snapshot.

## Safety checklist (before running)
- [ ] Snapshot created
- [ ] Network disabled or isolated
- [ ] No forwarding of ports from host to VM
- [ ] No real credentials on clipboard
- [ ] All participants signed a consent form (if testing with people)

## Consent template (short)
"I understand this test is educational. I will not enter any real credentials. I give permission for the demonstrator to show a local demo only."

## After the lab
- Revert the VM to the snapshot.
- Delete any temporary files that contain test inputs.
- Update your repository with notes about what you learned.

## Notes
- Do NOT deploy demo files to a public web server.
- If you want to show screenshots, blur or remove any real user data.
