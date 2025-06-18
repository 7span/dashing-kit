## Overview
This rule enforces the use of `flutter_gen` package for type-safe asset management in Flutter projects, replacing raw string asset paths with generated code.

## Rule Application

### ❌ NEVER Use Raw String Paths
**Avoid this pattern:**
```dart
// DON'T DO THIS
Image.asset("assets/demo.png")
Image.asset("assets/icons/home.svg")
Image.asset("assets/images/profile.jpg")
```

### ✅ ALWAYS Use Generated Asset Classes
**Use this pattern instead:**
```dart
// DO THIS
Assets.images.demo.image()
Assets.icons.home.svg()
Assets.images.profile.image()
```

## Implementation Steps

### 1. Asset Placement
- **ALWAYS** add assets to the `assets` folder in the **app_ui** package
- Organize assets by type (images, icons, fonts, etc.)
- Use descriptive, snake_case naming for asset files

### 2. Directory Structure
```
app_ui/
├── assets/
│   ├── images/
│   │   ├── demo.png
│   │   ├── profile.jpg
│   │   └── background.png
│   ├── icons/
│   │   ├── home.svg
│   │   ├── search.svg
│   │   └── settings.svg
│   └── fonts/
│       └── custom_font.ttf
```

### 3. Code Generation
After adding new assets, **ALWAYS** run:
```bash
melos run asset-gen
```

### 4. Usage Patterns

#### Images
```dart
// For PNG/JPG images
Assets.images.demo.image()
Assets.images.profile.image()
Assets.images.background.image()

// With additional properties
Assets.images.demo.image(
  width: 100,
  height: 100,
  fit: BoxFit.cover,
)
```

#### SVG Icons
```dart
// For SVG assets
Assets.icons.home.svg()
Assets.icons.search.svg()
Assets.icons.settings.svg()

// With color and size
Assets.icons.home.svg(
  color: Colors.blue,
  width: 24,
  height: 24,
)
```

#### Raw Asset Paths (when needed)
```dart
// If you need the path string
Assets.images.demo.path
Assets.icons.home.path
```

## Asset Type Mappings

### Common Asset Extensions and Usage
| Extension | Usage Pattern | Example |
|-----------|---------------|---------|
| `.png`, `.jpg`, `.jpeg` | `.image()` | `Assets.images.photo.image()` |
| `.svg` | `.svg()` | `Assets.icons.star.svg()` |
| `.json` | `.path` | `Assets.animations.loading.path` |
| `.ttf`, `.otf` | Reference in theme | Font family name |

## Implementation Checklist

### Adding New Assets:
- [ ] Place asset in appropriate folder within `app_ui/assets/`
- [ ] Use descriptive, snake_case naming
- [ ] Run `melos run asset-gen` command
- [ ] Verify asset appears in generated `Assets` class
- [ ] Update existing raw string references to use generated code

### Code Review Checklist:
- [ ] No raw string asset paths (`"assets/..."`)
- [ ] All assets use `Assets.category.name.method()` pattern
- [ ] Asset generation command run after adding new assets
- [ ] Unused assets removed from assets folder

## Common Patterns

### Image Widget
```dart
// Basic image
Assets.images.logo.image()

// Image with properties
Assets.images.banner.image(
  width: double.infinity,
  height: 200,
  fit: BoxFit.cover,
)

// Image in Container
Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: Assets.images.background.provider(),
      fit: BoxFit.cover,
    ),
  ),
)
```

### SVG Usage
```dart
// Basic SVG
Assets.icons.menu.svg()

// Styled SVG
Assets.icons.heart.svg(
  color: theme.primaryColor,
  width: 20,
  height: 20,
)

// SVG in IconButton
IconButton(
  onPressed: () {},
  icon: Assets.icons.settings.svg(),
)
```

### Asset Provider (for advanced usage)
```dart
// For use with other widgets that need ImageProvider
CircleAvatar(
  backgroundImage: Assets.images.avatar.provider(),
)

// For precaching
precacheImage(Assets.images.splash.provider(), context);
```

## Best Practices

### Naming Conventions
- Use `snake_case` for asset file names
- Be descriptive: `user_profile.png` instead of `img1.png`
- Group related assets: `icon_home.svg`, `icon_search.svg`

### Organization
- **images/**: Photos, illustrations, backgrounds
- **icons/**: SVG icons, small graphics
- **animations/**: Lottie files, GIFs
- **fonts/**: Custom font files

### Performance
- Use appropriate image formats (SVG for icons, PNG/JPG for photos)
- Optimize image sizes before adding to assets
- Consider using `precacheImage()` for critical images

## Migration from Raw Strings

### Find and Replace Pattern
1. Search for: `Image.asset("assets/`
2. Replace with appropriate `Assets.` pattern
3. Run asset generation if needed
4. Test all asset references

### Example Migration
```dart
// Before
Image.asset("assets/images/logo.png", width: 100)

// After  
Assets.images.logo.image(width: 100)
```

## Troubleshooting

### Asset Not Found
1. Verify asset exists in `app_ui/assets/` folder
2. Check file naming (no spaces, special characters)
3. Run `melos run asset-gen` command
4. Restart IDE/hot restart app

### Generated Code Not Updated
1. Run `melos run asset-gen` command
2. Check for build errors in terminal
3. Verify `flutter_gen` is properly configured in `pubspec.yaml`
4. Clean and rebuild project if necessary

## Overview
This rule enforces the use of the `app_ui` package components following the Atomic Design Pattern. The package provides consistent theming, spacing, and reusable components across the Flutter Launchpad project.

## 1. app_translations Package 📦

### Overview
The `app_translations` package manages localization in the application using the **slang** package. It provides type-safe, auto-generated translations for consistent internationalization across the Flutter Launchpad project.

### Implementation Rules

#### ✅ ALWAYS Use context.t for Text
**Correct Pattern:**
```dart
// Use generated translations
AppText.medium(text: context.t.welcome)
AppButton(text: context.t.submit, onPressed: () {})
```

#### ❌ NEVER Use Hardcoded Strings
**Avoid these patterns:**
```dart
// DON'T DO THIS
AppText.medium(text: "Welcome")
AppButton(text: "Submit", onPressed: () {})
```

### Adding New Translations

#### Step 1: Add Key-Value Pairs
Add translations to JSON files in the `i18n` folder within `app_translations` package:

**English (`en.json`):**
```json
{
  "login": "Login Screen",
  "welcome": "Welcome to the app",
  "submit": "Submit",
  "cancel": "Cancel",
  "loading": "Loading...",
}
```

**Other languages (e.g., `es.json`):**
```json
{
  "login": "Pantalla de Inicio de Sesión",
  "welcome": "Bienvenido a la aplicación",
  "submit": "Enviar",
  "cancel": "Cancelar",
  "loading": "Cargando...",
}
```

#### Step 2: Generate Code
After adding key-value pairs, run the generation command:
```bash
melos run locale-gen
```

#### Step 3: Use in Code
```dart

// In AppText widget
AppText.medium(text: context.t.welcome)

// In buttons
AppButton(
  text: context.t.submit,
  onPressed: () {},
)

AppText.small(text: context.t.error.validation)
```

### Troubleshooting

#### Translation Not Found
1. Verify key exists in JSON files
2. Check spelling and nested structure
3. Run `melos run locale-gen` to regenerate
4. Restart IDE/hot restart app

#### Generated Code Issues
1. Ensure JSON syntax is valid
2. Check for duplicate keys
3. Verify slang package configuration
4. Clean and rebuild project

## Package Structure
The `app_ui` package is organized using **Atomic Design Pattern**:
- 🎨 **App Themes** - Color schemes and typography
- 🔤 **Fonts** - Custom font configurations
- 📁 **Assets Storage** - Images, icons, and other assets
- 🧩 **Common Widgets** - Reusable UI components
- 🛠️ **Generated Files** - Auto-generated asset and theme files

## Atomic Design Levels

### 🛰️ Atoms (Basic Building Blocks)

#### Spacing Rules
**❌ NEVER Use Raw SizedBox for Spacing**
```dart
// DON'T DO THIS
const SizedBox(height: 8)
const SizedBox(width: 16)
const SizedBox(height: 24, width: 32)
```

**✅ ALWAYS Use VSpace and HSpace**
```dart
// DO THIS - Vertical spacing
VSpace.xsmall()    // Extra small vertical space
VSpace.small()     // Small vertical space  
VSpace.medium()    // Medium vertical space
VSpace.large()     // Large vertical space
VSpace.xlarge()    // Extra large vertical space

// Horizontal spacing
HSpace.xsmall()    // Extra small horizontal space
HSpace.small()     // Small horizontal space
HSpace.medium()    // Medium horizontal space
HSpace.large()     // Large horizontal space
HSpace.xlarge()    // Extra large horizontal space
```

#### Other Atom-Level Components
```dart
// Border radius
AppBorderRadius.small
AppBorderRadius.medium
AppBorderRadius.large

// Padding/margins
Insets.small
Insets.medium
Insets.large

// Text components
AppText.small(text: "Content")
AppText.medium(text: "Content")
AppText.large(text: "Content")

// Loading indicators
AppLoadingIndicator()
```

### 🔵 Molecules (Component Combinations)

#### Button Usage Rules
**❌ NEVER Use Raw Material Buttons**
```dart
// DON'T DO THIS
ElevatedButton(
  onPressed: () {},
  child: Text("Login"),
)

TextButton(
  onPressed: () {},
  child: Text("Cancel"),
)
```

**✅ ALWAYS Use AppButton**
```dart
// DO THIS - Basic button
AppButton(
  text: context.t.login,
  onPressed: () {},
)

// Expanded button
AppButton(
  text: context.t.submit,
  onPressed: () {},
  isExpanded: true,
)

// Disabled button
AppButton(
  text: context.t.save,
  onPressed: () {},
  isEnabled: false,
)

// Button variants
AppButton.secondary(
  text: context.t.cancel,
  onPressed: () {},
)

AppButton.outline(
  text: context.t.edit,
  onPressed: () {},
)

AppButton.text(
  text: context.t.skip,
  onPressed: () {},
)
```

## Spacing Implementation Patterns

### Column/Row Spacing
```dart
// Instead of multiple SizedBox widgets
Column(
  children: [
    Widget1(),
    VSpace.medium(),
    Widget2(),
    VSpace.small(),
    Widget3(),
  ],
)

Row(
  children: [
    Widget1(),
    HSpace.large(),
    Widget2(),
    HSpace.medium(),
    Widget3(),
  ],
)
```

### Complex Layout Spacing
```dart
// Combining vertical and horizontal spacing
Container(
  padding: Insets.medium,
  child: Column(
    spacing : EdgeInsets.all(Insets.small8),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText.large(text: context.t.title),
      VSpace.small(),
      AppText.medium(text: context.t.description),
      VSpace.large(),
      Row(
        children: [
          AppButton(
            text: context.t.confirm,
            onPressed: () {},
            isExpanded: true,
          ),
          HSpace.medium(),
          AppButton.secondary(
            text: context.t.cancel,
            onPressed: () {},
            isExpanded: true,
          ),
        ],
      ),
    ],
  ),
)
```

## Button Configuration Patterns

### Basic Button Usage
```dart
// Standard button
AppButton(
  text: context.t.login,
  onPressed: () => _handleLogin(),
)

// Button with loading state
AppButton(
  text: context.t.submit,
  onPressed: isLoading ? null : () => _handleSubmit(),
  isEnabled: !isLoading,
  child: isLoading ? AppLoadingIndicator.small() : null,
)
```

### Button Variants
```dart
// Primary button (default)
AppButton(
  text: context.t.save,
  onPressed: () {},
)

// Secondary button
AppButton.secondary(
  text: context.t.cancel,
  onPressed: () {},
)

// Outline button
AppButton.outline(
  text: context.t.edit,
  onPressed: () {},
)

// Text button
AppButton.text(
  text: context.t.skip,
  onPressed: () {},
)

// Destructive button
AppButton.destructive(
  text: context.t.delete,
  onPressed: () {},
)
```

### Button Properties
```dart
AppButton(
  text: context.t.action,
  onPressed: () {},
  isExpanded: true,        // Full width button
  isEnabled: true,         // Enable/disable state
  isLoading: false,        // Loading state
  icon: Icons.save,        // Leading icon
  suffixIcon: Icons.arrow_forward, // Trailing icon
  backgroundColor: context.colorScheme.primary,
  textColor: context.colorScheme.onPrimary,
)
```

## App UI Component Categories

### Atoms
```dart
// Spacing
VSpace.small()
HSpace.medium()

// Text
AppText.medium(text: "Content")

// Border radius
AppBorderRadius.large

// Padding
Insets.all16

// Loading
AppLoadingIndicator()
```

### Molecules
```dart
// Buttons
AppButton(text: "Action", onPressed: () {})

// Input fields
AppTextField(
  label: context.t.email,
  controller: emailController,
)

// Cards
AppCard(
  child: Column(children: [...]),
)
```

### Organisms
```dart
// Forms
AppForm(
  children: [
    AppTextField(...),
    VSpace.medium(),
    AppButton(...),
  ],
)

// Navigation
AppBottomNavigationBar(
  items: [...],
)
```

## Customization Guidelines

### Modifying Spacing
**Edit `spacing.dart`:**
```dart
class VSpace extends StatelessWidget {
  static Widget xsmall() => const SizedBox(height: 4);
  static Widget small() => const SizedBox(height: 8);
  static Widget medium() => const SizedBox(height: 16);
  static Widget large() => const SizedBox(height: 24);
  static Widget xlarge() => const SizedBox(height: 32);
}
```

### Modifying Buttons
**Edit `app_button.dart`:**
```dart
class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    this.isExpanded = false,
    this.isEnabled = true,
    // Add more customization options
  });
}
```

## Common Usage Patterns

### Form Layout
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    AppText.large(text: context.t.loginTitle),
    VSpace.large(),
    AppTextField(
      label: context.t.email,
      controller: emailController,
    ),
    VSpace.medium(),
    AppTextField(
      label: context.t.password,
      controller: passwordController,
      obscureText: true,
    ),
    VSpace.large(),
    AppButton(
      text: context.t.login,
      onPressed: () => _handleLogin(),
      isExpanded: true,
    ),
    VSpace.small(),
    AppButton.text(
      text: context.t.forgotPassword,
      onPressed: () => _navigateToForgotPassword(),
    ),
  ],
)
```

### Card Layout
```dart
AppCard(
  padding: Insets.medium,
  borderRadius: AppBorderRadius.medium,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText.large(text: context.t.cardTitle),
      VSpace.small(),
      AppText.medium(text: context.t.cardDescription),
      VSpace.medium(),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppButton.text(
            text: context.t.cancel,
            onPressed: () {},
          ),
          HSpace.small(),
          AppButton(
            text: context.t.confirm,
            onPressed: () {},
          ),
        ],
      ),
    ],
  ),
)
```

### List Item Spacing
```dart
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (context, index) => VSpace.small(),
  itemBuilder: (context, index) => ListTile(
    title: AppText.medium(text: items[index].title),
    subtitle: AppText.small(text: items[index].subtitle),
    trailing: AppButton.text(
      text: context.t.view,
      onPressed: () => _viewItem(items[index]),
    ),
  ),
)
```

## Best Practices

### Spacing Consistency
- Use predefined spacing values from `VSpace`/`HSpace`
- Maintain consistent spacing ratios throughout the app
- Group related elements with smaller spacing
- Separate different sections with larger spacing

### Component Reusability
- Extend app_ui components rather than creating new ones
- Follow atomic design principles
- Keep components configurable but opinionated
- Maintain consistent API patterns across components

### Performance
- Use `const` constructors where possible
- Avoid rebuilding spacing widgets unnecessarily
- Cache complex spacing calculations

## Migration Guide

### From Raw Spacing
```dart
// Before
const SizedBox(height: 16)

// After
VSpace.medium()
```

### From Raw Buttons
```dart
// Before
ElevatedButton(
  onPressed: () {},
  child: Text("Submit"),
)

// After
AppButton(
  text: context.t.submit,
  onPressed: () {},
)
```

## Overview
This rule ensures consistent implementation of Auto Route navigation in Flutter applications with proper annotations, route configurations, and BLoC integration.

## Rule Application

### 1. Screen Widget Annotation
- **ALWAYS** annotate screen widgets with `@RoutePage()` decorator
- Place the annotation directly above the class declaration
- No additional parameters needed for basic routes

### 2. For simple screens without state management:
```dart
@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return // Your widget implementation
  }
}
```

### 3. For screens requiring state management with BLoC/Cubit:
```dart
@RoutePage()
class HomeScreen extends StatefulWidget implements AutoRouteWrapper {
  const HomeScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => HomeRepository()),
        RepositoryProvider(create: (context) => ProfileRepository()),
        RepositoryProvider(create: (context) => const AuthRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) => HomeBloc(
              repository: context.read<HomeRepository>()
            )..safeAdd(const FetchPostsEvent()),
          ),
          BlocProvider(
            create: (context) => ProfileCubit(
              context.read<AuthRepository>(),
              context.read<ProfileRepository>(),
            )..fetchProfileDetail(),
          ),
        ],
        child: this,
      ),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
```

### 4. Route Configuration in app_router.dart
```dart
@AutoRouterConfig(replaceInRouteName: 'Page|Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      page: SplashRoute.page,
      guards: [AuthGuard()],
    ),
    AutoRoute(page: HomeRoute.page),
    // Add new routes here
  ];
}
```

### 5. Code Generation Command
After adding new routes, **ALWAYS** run:
```bash
melos run build-runner
```

### 6. Use BackButtonListener instead of PopScope while project contains AutoRoute to avoid conflicts because of auto_route.
For this you can wrap the AppScafflold with BackButtonListener like this,
```dart
@override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: (){},
      child: AppScafflold(),
    );
  }
```

## Implementation Checklist

### For New Screens:
- [ ] Add `@RoutePage()` annotation above class declaration
- [ ] Choose appropriate pattern (StatelessWidget vs StatefulWidget with AutoRouteWrapper)
- [ ] If using BLoC, implement `AutoRouteWrapper` interface
- [ ] Add route configuration in `app_router.dart`
- [ ] Run build runner command
- [ ] Verify route generation in generated files

### For BLoC Integration:
- [ ] Implement `AutoRouteWrapper` interface
- [ ] Use `MultiRepositoryProvider` for dependency injection
- [ ] Use `MultiBlocProvider` for state management
- [ ] Initialize BLoCs with required repositories
- [ ] Return `this` as child in wrapper

### Route Configuration:
- [ ] Add route to `routes` list in `AppRouter`
- [ ] Use `RouteNameHere.page` format
- [ ] Add guards if authentication required
- [ ] Set `initial: true` for entry point routes

## Common Patterns

### Basic Navigation Route
```dart
AutoRoute(page: ScreenNameRoute.page)
```

### Protected Route with Guard
```dart
AutoRoute(
  page: ScreenNameRoute.page,
  guards: [AuthGuard()],
)
```

### Initial/Entry Route
```dart
AutoRoute(
  initial: true,
  page: SplashRoute.page,
  guards: [AuthGuard()],
)
```

## Notes
- Route names are automatically generated based on screen class names
- The `replaceInRouteName` parameter converts 'Page' or 'Screen' suffixes to 'Route'
- Always run code generation after route changes
- Use lazy loading for BLoCs when appropriate (set `lazy: false` for immediate initialization)

# Bloc Rules
## Overview
The BLoC layer serves as the bridge between UI and data layers, managing application state through events and state emissions. This layer follows a strict architectural pattern with three core components.

## BLoC Architecture Components

| Component | Purpose | Description |
|-----------|---------|-------------|
| **State file 💽** | Data Holder | Contains reference to data displayed in UI |
| **Event file ▶️** | UI Triggers | Holds events triggered from the UI layer |
| **BLoC file 🔗** | Logic Controller | Connects State and Event, performs business logic |

## 1. Event File Implementation ⏭️

### Event Class Structure
- **Use sealed classes** instead of abstract classes for events
- **Implement with final classes** for concrete event types
- **Name in past tense** - events represent actions that have already occurred

```dart
part of '[feature]_bloc.dart';

sealed class [Feature]Event extends Equatable {
  const [Feature]Event();

  @override
  List<Object> get props => [];
}

final class [Feature]GetDataEvent extends [Feature]Event {
  const [Feature]GetDataEvent();
}
```

### Event Naming Conventions
- **Base Event Class**: `[BlocSubject]Event`
- **Initial Load Events**: `[BlocSubject]Started`
- **Action Events**: `[BlocSubject][Action]Event`
- **Past Tense**: Events represent completed user actions

### Event Examples
```dart
// Good examples
final class HomeGetPostEvent extends HomeEvent {...}
final class ProfileUpdateEvent extends ProfileEvent {...}
final class AuthLoginEvent extends AuthEvent {...}

// Initial load events
final class HomeStarted extends HomeEvent {...}
final class ProfileStarted extends ProfileEvent {...}
```

## 2. State File Implementation 📌

### State Class Structure
- **Hybrid approach**: Combines Named Constructors and copyWith methods
- **Equatable implementation**: For proper state comparison
- **Private constructor**: Main constructor should be private
- **ApiStatus integration**: Use standardized status enum

```dart
part of '[feature]_bloc.dart';

class [Feature]State extends Equatable {
  final List<[Feature]Model> dataList;
  final bool hasReachedMax;
  final ApiStatus status;
  
  const [Feature]State._({
    this.dataList = const <[Feature]Model>[],
    this.hasReachedMax = false,
    this.status = ApiStatus.initial,
  });

  // Named constructors for common states
  const [Feature]State.initial() : this._(status: ApiStatus.initial);
  const [Feature]State.loading() : this._(status: ApiStatus.loading);
  const [Feature]State.loaded(List<[Feature]Model> dataList, bool hasReachedMax)
      : this._(
          status: ApiStatus.loaded,
          dataList: dataList,
          hasReachedMax: hasReachedMax,
        );
  const [Feature]State.error() : this._(status: ApiStatus.error);

  [Feature]State copyWith({
    ApiStatus? status,
    List<[Feature]Model>? dataList,
    bool? hasReachedMax,
  }) {
    return [Feature]State._(
      status: status ?? this.status,
      dataList: dataList ?? this.dataList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [dataList, hasReachedMax, status];

  @override
  bool get stringify => true;
}
```

### State Design Patterns
- **Private Main Constructor**: Use `._()` pattern
- **Named Constructors**: For common state scenarios
- **CopyWith Method**: For incremental state updates
- **Proper Props**: Include all relevant fields in props list
- **Stringify**: Enable for better debugging

### ApiStatus Enum Usage
```dart
enum ApiStatus {
  initial,    // Before any operation
  loading,    // During API call
  loaded,     // Successful data fetch
  error,      // API call failed
}
```

## 3. BLoC File Implementation 🟦

### BLoC Class Structure
```dart
class [Feature]Bloc extends Bloc<[Feature]Event, [Feature]State> {
  [Feature]Bloc({required this.repository}) : super(const [Feature]State.initial()) {
    on<[Feature]GetDataEvent>(_on[Feature]GetDataEvent, transformer: droppable());
  }
  
  final I[Feature]Repository repository;
  int _pageCount = 1;

  FutureOr<void> _on[Feature]GetDataEvent(
    [Feature]GetDataEvent event,
    Emitter<[Feature]State> emit,
  ) async {
    if (state.hasReachedMax) return;

    // Show loader only on initial load
    state.status == ApiStatus.initial
        ? emit(const [Feature]State.loading())
        : emit([Feature]State.loaded(state.dataList, false));

    final dataEither = await repository.fetchData(page: _pageCount).run();
    
    dataEither.fold(
      (error) => emit(const [Feature]State.error()),
      (result) {
        emit([Feature]State.loaded(
          state.dataList.followedBy(result).toList(),
          false,
        ));
        _pageCount++;
      },
    );
  }
}
```

### BLoC Implementation Patterns
- **Repository Injection**: Always inject repository through constructor
- **Event Transformers**: Use appropriate transformers (droppable, concurrent, sequential)
- **State Management**: Check current state before emitting new states
- **Error Handling**: Use TaskEither fold method for error handling
- **Pagination Logic**: Implement proper pagination tracking

### Event Transformers
```dart
// Use droppable for operations that shouldn't be queued
on<Event>(_handler, transformer: droppable());

// Use concurrent for independent operations
on<Event>(_handler, transformer: concurrent());

// Use sequential for ordered operations (default)
on<Event>(_handler, transformer: sequential());
```

## 4. UI Integration with AutoRoute 🎁

### Screen Implementation with Providers
```dart
class [Feature]Screen extends StatefulWidget implements AutoRouteWrapper {
  const [Feature]Screen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider<[Feature]Repository>(
      create: (context) => [Feature]Repository(),
      child: BlocProvider(
        lazy: false,
        create: (context) => [Feature]Bloc(
          repository: RepositoryProvider.of<[Feature]Repository>(context),
        )..add(const [Feature]GetDataEvent()),
        child: this,
      ),
    );
  }

  @override
  State<[Feature]Screen> createState() => _[Feature]ScreenState();
}
```

### Provider Pattern Guidelines
- **AutoRouteWrapper**: Implement for scoped provider injection
- **RepositoryProvider**: Provide repository instances
- **BlocProvider**: Provide BLoC instances with repository injection
- **Lazy Loading**: Set `lazy: false` for immediate initialization
- **Initial Events**: Add initial events in BLoC creation

## Development Guidelines

### File Organization
```dart
// Event file structure
part of '[feature]_bloc.dart';
sealed class [Feature]Event extends Equatable {...}

// State file structure  
part of '[feature]_bloc.dart';
class [Feature]State extends Equatable {...}

// BLoC file structure
import 'package:bloc/bloc.dart';
part '[feature]_event.dart';
part '[feature]_state.dart';
```

### Naming Conventions
- **BLoC Class**: `[Feature]Bloc`
- **State Class**: `[Feature]State`  
- **Event Base Class**: `[Feature]Event`
- **Event Handlers**: `_on[Feature][Action]Event`
- **Private Fields**: Use underscore prefix for internal state

### Error Handling Patterns
```dart
// Standard error handling with fold
final resultEither = await repository.operation().run();
resultEither.fold(
  (failure) => emit(const FeatureState.error()),
  (success) => emit(FeatureState.loaded(success)),
);
```

### State Emission Best Practices
- **Check Current State**: Prevent unnecessary emissions
- **Loading States**: Show loader only when appropriate
- **Error Recovery**: Provide ways to retry failed operations
- **Pagination**: Handle has-reached-max scenarios

## Testing Considerations

### BLoC Testing Structure
```dart
group('[Feature]Bloc', () {
  late [Feature]Bloc bloc;
  late Mock[Feature]Repository mockRepository;

  setUp(() {
    mockRepository = Mock[Feature]Repository();
    bloc = [Feature]Bloc(repository: mockRepository);
  });

  blocTest<[Feature]Bloc, [Feature]State>(
    'emits loaded state when event succeeds',
    build: () => bloc,
    act: (bloc) => bloc.add(const [Feature]GetDataEvent()),
    expect: () => [
      const [Feature]State.loading(),
      isA<[Feature]State>().having((s) => s.status, 'status', ApiStatus.loaded),
    ],
  );
});
```

### Build Runner Commands
```bash
# Generate necessary files
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch

# Clean and rebuild
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Performance Optimizations

### Memory Management
- **Proper Disposal**: BLoC automatically handles disposal
- **Stream Subscriptions**: Cancel in BLoC close method if manually created
- **Repository Scoping**: Scope repositories to feature level

### Event Handling Efficiency
- **Debouncing**: Use appropriate transformers for user input
- **Caching**: Implement at repository level, not BLoC level
- **Pagination**: Implement proper pagination logic to avoid memory issues

## Overview
This rule enforces consistent usage of colors in project.

If you look at the `extensions.dart` file, you will be able to see extensions related to accessing colors and textstyles.
we follow material conventions. So to use any color, you can use context.colorscheme like this:

```dart
Container(color:context.colorScheme.primary)
```

Use AppText instead of Text widget to utilise typography.
```dart
AppText.medium(
 text:context.t.login,
 color: context.colorScheme.primary,
),
```

Same way, You can use TextStyles using context.textTheme.

```dart
RichText(
  text: TextSpan(
    text: context.t.login,
    Style: context.textTheme.medium,
    )
)
```
# Effective Dart Rules

### Naming Conventions
1. Use terms consistently throughout your code.
2. Name types using `UpperCamelCase` (classes, enums, typedefs, type parameters).
3. Name extensions using `UpperCamelCase`.
4. Name packages, directories, and source files using `lowercase_with_underscores`.
5. Name import prefixes using `lowercase_with_underscores`.
6. Name other identifiers using `lowerCamelCase` (variables, parameters, named parameters).
7. Capitalize acronyms and abbreviations longer than two letters like words.
8. Avoid abbreviations unless the abbreviation is more common than the unabbreviated term.
9. Prefer putting the most descriptive noun last in names.
10. Prefer a noun phrase for non-boolean properties or variables.

### Architecture
1. Separate your features into three layers: Presentation, Business Logic, and Data.
2. The Data Layer is responsible for retrieving and manipulating data from sources such as databases or network requests.
3. Structure the Data Layer into repositories (wrappers around data providers) and data providers (perform CRUD operations).
4. The Business Logic Layer responds to input from the presentation layer and communicates with repositories to build new states.
5. The Presentation Layer renders UI based on bloc states and handles user input and lifecycle events.
6. Inject repositories into blocs via constructors; blocs should not directly access data providers.
7. Avoid direct bloc-to-bloc communication to prevent tight coupling.
8. To coordinate between blocs, use BlocListener in the presentation layer to listen to one bloc and add events to another.
9. For shared data, inject the same repository into multiple blocs; let each bloc listen to repository streams independently.
10. Always strive for loose coupling between architectural layers and components.
11. Structure your project consistently and intentionally; there is no single right way.
12. Follow repository pattern with abstract interfaces (IAuthRepository) and concrete implementations
13. Use TaskEither from fpdart for functional error handling instead of try-catch blocks
14. Implement mapping functions that separate API calls from response processing
15. Chain operations using .chainEither() and .flatMap() for clean functional composition
16. Always use RepositoryUtils.checkStatusCode for status validation and RepositoryUtils.mapToModel for JSON parsing

### Types and Functions
1. Use class modifiers to control if your class can be extended or used as an interface.
2. Type annotate fields and top-level variables if the type isn't obvious.
3. Annotate return types on function declarations.
4. Annotate parameter types on function declarations.
5. Use `Future<void>` as the return type of asynchronous members that do not produce values.
6. Use getters for operations that conceptually access properties.
7. Use setters for operations that conceptually change properties.
8. Use inclusive start and exclusive end parameters to accept a range.

### Style and Structure
1. Prefer `final` over `var` when variable values won't change.
2. Use `const` for compile-time constants.
3. Keep files focused on a single responsibility.
4. Limit file length to maintain readability.
5. Group related functionality together.
6. Prefer making declarations private.

### Imports & Files
1. Don't import libraries inside the `src` directory of another package.
2. Prefer relative import paths within a package.
3. Don't use `/lib/` or `../` in import paths.
4. Consider writing a library-level doc comment for library files.

### Usage
1. Use strings in `part of` directives.
2. Use adjacent strings to concatenate string literals.
3. Use collection literals when possible.
4. Use `whereType()` to filter a collection by type.
5. Test for `Future<T>` when disambiguating a `FutureOr<T>` whose type argument could be `Object`.
6. Initialize fields at their declaration when possible.
7. Use initializing formals when possible.
8. Use `;` instead of `{}` for empty constructor bodies.
9. Use `rethrow` to rethrow a caught exception.
10. Override `hashCode` if you override `==`.
11. Make your `==` operator obey the mathematical rules of equality.

### Documentation
1. Use `///` doc comments to document members and types; don't use block comments for documentation.
2. Prefer writing doc comments for public APIs.
3. Start doc comments with a single-sentence summary.
4. Use square brackets in doc comments to refer to in-scope identifiers.
### Flutter Best Practices
1. Extract reusable widgets into separate components.
2. Use `StatelessWidget` when possible.
3. Keep build methods simple and focused.
4. Avoid unnecessary `StatefulWidget`s.
5. Keep state as local as possible.
6. Use `const` constructors when possible.
7. Avoid expensive operations in build methods.
8. Implement pagination for large lists.

### Dart 3: Records
1. Records are anonymous, immutable, aggregate types that bundle multiple objects into a single value.
2. Records are fixed-sized, heterogeneous, and strongly typed. Each field can have a different type.
3. Record expressions use parentheses with comma-delimited positional and/or named fields, e.g. `('first', a: 2, b: true, 'last')`.
4. Record fields are accessed via built-in getters: positional fields as `$1`, `$2`, etc., and named fields by their name (e.g., `.a`).
5. Records are immutable: fields do not have setters.
6. Use records for functions that return multiple values; destructure with pattern matching: `var (name, age) = userInfo(json);`
7. Use type aliases (`typedef`) for record types to improve readability and maintainability.
8. Records are best for simple, immutable data aggregation; use classes for abstraction, encapsulation, and behavior.

### Dart 3: Patterns
1. Patterns represent the shape of values for matching and destructuring.
2. Pattern matching checks if a value has a certain shape, constant, equality, or type.
3. Pattern destructuring allows extracting parts of a matched value and binding them to variables.
4. Use wildcard patterns (`_`) to ignore parts of a matched value.
5. Use rest elements (`...`, `...rest`) in list patterns to match arbitrary-length lists.
6. Use logical-or patterns (e.g., `case a || b`) to match multiple alternatives in a single case.
7. Add guard clauses (`when`) to further constrain when a case matches.
8. Use the `sealed` modifier on a class to enable exhaustiveness checking when switching over its subtypes.

### Common Flutter Errors
1. If you get a "RenderFlex overflowed" error, check if a `Row` or `Column` contains unconstrained widgets. Fix by wrapping children in `Flexible`, `Expanded`, or by setting constraints.
2. If you get "Vertical viewport was given unbounded height", ensure `ListView` or similar scrollable widgets inside a `Column` have a bounded height.
3. If you get "An InputDecorator...cannot have an unbounded width", constrain the width of widgets like `TextField`.
4. If you get a "setState called during build" error, do not call `setState` or `showDialog` directly inside the build method.
5. If you get "The ScrollController is attached to multiple scroll views", make sure each `ScrollController` is only attached to a single scrollable widget.
6. If you get a "RenderBox was not laid out" error, check for missing or unbounded constraints in your widget tree.
7. Use the Flutter Inspector and review widget constraints to debug layout issues.

### Base Module Location
All features must be created within the `lib/modules` directory of the `app_core` package:

```
lib
└── modules 
    └── [feature_name]
```

### Feature Folder Structure
Each feature follows a consistent 4-folder architecture:

```
lib
└── modules
   ├── [feature_name]
   │   ├── bloc/
   │   │   ├── [feature]_event.dart
   │   │   ├── [feature]_state.dart
   │   │   └── [feature]_bloc.dart
   │   ├── model/
   │   │   └── [feature]_model.dart
   │   ├── repository/
   │   │   └── [feature]_repository.dart
   │   └── screen/
   │       └── [feature]_screen.dart
```

## Folder Responsibilities

| Folder | Purpose | Contains |
|--------|---------|----------|
| **bloc** 🧱 | State Management | BLoC, Event, and State classes for the feature |
| **model** 🏪 | Data Models | Dart model classes for JSON serialization/deserialization |
| **repository** 🪣 | API Integration | Functions for API calls and data manipulation |
| **screen** 📲 | User Interface | UI components and screens for the feature |

## Repository Layer Implementation

### Core Pattern: TaskEither Approach
All API integrations use `TaskEither<Failure, T>` pattern from `fp_dart` for functional error handling.

### Abstract Interface Structure
```dart
abstract interface class I[Feature]Repository {
  /// Returns TaskEither where:
  /// - Task: Indicates Future operation
  /// - Either: Success (T) or Failure handling
  TaskEither<Failure, List<[Feature]Model>> fetch[Data]();
}
```

### Implementation Steps

#### 1. HTTP Request Layer 🎁
```dart
class [Feature]Repository implements I[Feature]Repository {
  @override
  TaskEither<Failure, List<[Feature]Model>> fetch[Data]() => 
      mappingRequest('[endpoint]');

  TaskEither<Failure, Response> make[Operation]Request(String url) {
    return ApiClient.request(
      path: url,
      queryParameters: {'_limit': 10},
      requestType: RequestType.get,
    );
  }
}
```

#### 2. Response Validation ✔️
```dart
TaskEither<Failure, List<[Feature]Model>> mappingRequest(String url) =>
    make[Operation]Request(url)
    .chainEither(checkStatusCode);

Either<Failure, Response> checkStatusCode(Response response) => 
    Either<Failure, Response>.fromPredicate(
      response,
      (response) => response.statusCode == 200 || response.statusCode == 304,
      (error) => APIFailure(error: error),
    );
```

#### 3. JSON Decoding 🔁
```dart
TaskEither<Failure, List<[Feature]Model>> mappingRequest(String url) =>
    make[Operation]Request(url)
    .chainEither(checkStatusCode)
    .chainEither(mapToList);

Either<Failure, List<Map<String, dynamic>>> mapToList(Response response) {
  return Either<Failure, List<Map<String, dynamic>>>.safeCast(
    response.data,
    (error) => ModelConversionFailure(error: error),
  );
}
```

#### 4. Model Conversion ✅
```dart
TaskEither<Failure, List<[Feature]Model>> mappingRequest(String url) =>
    make[Operation]Request(url)
    .chainEither(checkStatusCode)
    .chainEither(mapToList)
    .flatMap(mapToModel);

TaskEither<Failure, List<[Feature]Model>> mapToModel(
  List<Map<String, dynamic>> responseList
) => TaskEither<Failure, List<[Feature]Model>>.tryCatch(
  () async => responseList.map([Feature]Model.fromJson).toList(),
  (error, stackTrace) => ModelConversionFailure(
    error: error,
    stackTrace: stackTrace,
  ),
);
```

## Development Guidelines

### Naming Conventions
- **Feature Names**: Use descriptive, lowercase names (auth, home, profile, settings)
- **File Names**: Follow pattern `[feature]_[type].dart`
- **Class Names**: Use PascalCase with feature prefix (`HomeRepository`, `HomeBloc`)
- **Method Names**: Use camelCase with descriptive verbs (`fetchPosts`, `updateProfile`)

### Error Handling Strategy
- **Consistent Failures**: Use standardized `Failure` classes
  - `APIFailure`: For HTTP/network errors
  - `ModelConversionFailure`: For JSON parsing errors
- **Functional Approach**: Chain operations using `TaskEither`
- **No Exceptions**: Handle all errors through `Either` types

### API Integration Patterns
1. **Abstract Interface**: Define contract with abstract interface class
2. **Implementation**: Implement interface in concrete repository class
3. **Function Chaining**: Use `.chainEither()` and `.flatMap()` for sequential operations
4. **Error Propagation**: Let `TaskEither` handle error propagation automatically

### BLoC Integration
- Repository layer feeds directly into BLoC layer
- BLoC handles UI state management
- Repository focuses purely on data operations
- Maintain separation of concerns between layers

## Best Practices

### Code Organization
- Keep abstract interface and implementation in same file for discoverability
- Create separate functions for each operation step
- Use descriptive function names that indicate their purpose
- Maintain consistent error handling patterns across all repositories

### Performance Considerations
- Leverage `TaskEither` for lazy evaluation
- Chain operations efficiently to avoid nested callbacks
- Use appropriate query parameters for data limiting
- Implement proper caching strategies in API client layer

### Testing Strategy
- Mock abstract interfaces for unit testing
- Test each step of the repository chain individually
- Verify error handling for all failure scenarios
- Ensure proper model conversion testing

## Example Feature Names
- `auth` - Authentication and authorization
- `home` - Home screen and dashboard
- `profile` - User profile management
- `settings` - Application settings
- `notifications` - Push notifications
- `search` - Search functionality
- `chat` - Messaging features
