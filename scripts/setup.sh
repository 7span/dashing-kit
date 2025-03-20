echo "Generating env config files"

cat <<EOT >> apps/app_core/.env.dev
BASE_API_URL=https://reqres.in/api/
BASE_API_KEY=https://jsonplaceholder.typicode.com/ 
ENV=Development
EOT


cat <<EOT >> apps/app_core/.env.prod
BASE_API_URL=https://reqres.in/api/
BASE_API_KEY=https://jsonplaceholder.typicode.com/ 
ENV=Production
EOT

cat <<EOT >> apps/app_core/.env.staging
BASE_API_URL=https://reqres.in/api/
BASE_API_KEY=https://jsonplaceholder.typicode.com/ 
ENV=Staging
EOT

melos bs

echo "Generate build runner files"
melos run build-runner

echo "Generate asset files"
melos run asset-gen

echo "Generate locale files"
melos run locale-gen

echo "Enabling Git Hooks"
dart run husky install