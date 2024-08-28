echo "Generating env config files"

cat <<EOT >> apps/app_core/.env.dev
ENV_BASE_API_URL=https://jsonplaceholder.typicode.com/ 
ENV_NAME=Development
EOT


cat <<EOT >> apps/app_core/.env.prod
ENV_BASE_API_URL=https://jsonplaceholder.typicode.com/ 
ENV_NAME=Development
EOT

cat <<EOT >> apps/app_core/.env.staging
ENV_BASE_API_URL=https://jsonplaceholder.typicode.com/ 
ENV_NAME=Development
EOT

melos bs

echo "Generate build runner files"
melos run build-runner

echo "Generate asset files"
melos run asset-gen

echo "Generate locale files"
melos run locale-gen