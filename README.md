# Boilerplate

1. Activate melos:
   `dart pub global activate melos`

2. Open this project and run the command below:
   `melos bs`

3. Enable Git Hooks
   `dart run husky install`

4. Generate Assets
   `melos run asset-gen`

> [!WARNING]
> **Before moving to Step 5, Make sure that you've done the setup of `env` files before moving
> further [Link for Setup ENV files](https://cavin-7span.github.io/Dash-Docs/docs/tutorial-basics/configuring-environment-variables)
**

5. Run build runner command to generate the configuration files such as assets, environments or
   routing
   `melos run build-runner`

6. Run this command to generate localization
   `melos run locale-gen`