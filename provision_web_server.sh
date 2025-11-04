#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Script: provision_web_server.sh
# Description:
#   This script automates the provisioning of a secure web server
#   (Nginx + HTTPS + Firewall) on Debian/Ubuntu systems.
#   It applies cybersecurity hardening best practices and deploys
#   a default test website automatically.
# ----------------------------------------------------------------------

set -euo pipefail
IFS=$'\n\t'

# === CONFIGURAÇÕES INICIAIS ===
DOMAIN="meusite.local"         # altere para seu domínio real
ADMIN_EMAIL="admin@meusite.local"
WEB_ROOT="/var/www/${DOMAIN}"
LOG_FILE="/var/log/provision_web_server.log"

# === FUNÇÃO DE LOG ===
log() {
  echo "$(date '+%F %T') - $1" | tee -a "$LOG_FILE"
}

# === VERIFICAÇÃO DE ROOT ===
if [[ $EUID -ne 0 ]]; then
  echo "❌ Este script precisa ser executado como root."
  exit 1
fi

log "Iniciando provisionamento do servidor web..."

# === ATUALIZA SISTEMA ===
log "Atualizando pacotes..."
apt update -y && apt upgrade -y

# === INSTALA PACOTES ESSENCIAIS ===
log "Instalando pacotes necessários..."
apt install -y nginx ufw fail2ban curl unzip software-properties-common

# === CONFIGURA FIREWALL ===
log "Configurando firewall..."
ufw allow 'OpenSSH'
ufw allow 'Nginx Full'
ufw --force enable

# === CONFIGURA NGINX ===
log "Configurando Nginx..."
mkdir -p "$WEB_ROOT/html"
chown -R www-data:www-data "$WEB_ROOT"
chmod -R 755 "$WEB_ROOT"

# Cria página de teste
cat <<EOF > "$WEB_ROOT/html/index.html"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Servidor Web Seguro</title>
<style>
body { font-family: Arial; background: #121212; color: #00ff99; text-align:center; margin-top:10%; }
h1 { font-size: 2.5rem; }
p { color: #ccc; }
</style>
</head>
<body>
<h1>Servidor Web Provisionado com Sucesso 🚀</h1>
<p>Seu ambiente está pronto para hospedar aplicações seguras.</p>
</body>
</html>
EOF

# Cria configuração Nginx
NGINX_CONF="/etc/nginx/sites-available/${DOMAIN}"
cat <<EOF > "$NGINX_CONF"
server {
    listen 80;
    server_name ${DOMAIN};

    root ${WEB_ROOT}/html;
    index index.html;

    access_log /var/log/nginx/${DOMAIN}_access.log;
    error_log /var/log/nginx/${DOMAIN}_error.log;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

ln -sf "$NGINX_CONF" "/etc/nginx/sites-enabled/"
nginx -t && systemctl restart nginx

# === INSTALA HTTPS (CERTBOT) ===
log "Instalando Certbot (HTTPS automático)..."
apt install -y certbot python3-certbot-nginx

# OBS: Se o domínio for público, descomente a linha abaixo:
# certbot --nginx -d $DOMAIN -m $ADMIN_EMAIL --agree-tos --redirect -n

# === CONFIGURA SEGURANÇA ADICIONAL ===
log "Aplicando hardening básico..."
# Remove servidores desnecessários
apt purge -y apache2 || true
# Desativa listagem de diretórios
sed -i '/autoindex on;/d' /etc/nginx/sites-available/* || true
# Oculta versão do servidor
sed -i 's/# server_tokens off;/server_tokens off;/' /etc/nginx/nginx.conf

# Reinicia serviços
systemctl reload nginx
systemctl enable nginx
systemctl enable fail2ban

# === RELATÓRIO FINAL ===
log "Provisionamento concluído com sucesso."
echo
echo "✅ Servidor Web Provisionado com sucesso!"
echo "🌐 Acesse: http://${DOMAIN}"
echo "📂 Raiz do site: ${WEB_ROOT}/html"
echo "🧱 Firewall ativo e Fail2Ban configurado."
echo
echo "Log completo: ${LOG_FILE}"
