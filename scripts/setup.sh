echo "Generating env config files"

cat <<EOT >> apps/app_core/.env.dev
    BASE_API_URL=https://jsonplaceholder.typicode.com/ 
    ENV=Development
EOT


cat <<EOT >> apps/app_core/.env.prod
    BASE_API_URL=https://jsonplaceholder.typicode.com/ 
    ENV=Development
EOT

cat <<EOT >> apps/app_core/.env.staging
    BASE_API_URL=https://jsonplaceholder.typicode.com/ 
    ENV=Development
EOT


echo "Generate build runner files"
melos run build-runner

echo "Generate asset files"
melos run asset-gen

echo "Generate locale files"
melos run locale-gen