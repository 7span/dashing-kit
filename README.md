# Boilerplate

1. Activate melos:
`dart pub global activate melos`

2. Open this project and run the command below:
`melos bs`

3. Enable Git Hooks
`dart run husky install`


> [!WARNING] 
> **Before step 4, Configure that you've done the setup of `env` files before moving further**

4. Run build runner command to generate the configuration files such as assets, enviroments or routing
`melos run build-runner`

5. Run this command to generate localization
`melos run locale-gen`