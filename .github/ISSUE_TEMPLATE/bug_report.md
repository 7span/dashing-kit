---
name: Bug report
about: Create a report to help us improve
title: ''
labels: ''
assignees: cavin
---
**Fill in the template.**

**Describe the bug**
A clear and concise description of what the bug is.

**Reproduction code
NOTE: THIS IS MANDATORY **

example:

```dart
void main() => runApp(MaterialApp(home: Home()));

class Home extends StatelessWidget {
  final count = 0;
  @override
  Widget build(context) => Scaffold(
      appBar: AppBar(title: Text("Demo")),
      body: Center(
        child: Text("$count"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => count++,
      ));
}
```

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Flutter Version:**
Enter the version of the Flutter you are using


**Describe on which device you found the bug:**
ex: Samsung Galaxy M30s - Android.

**Minimal reproduce code**
Provide a minimum reproduction code for the problem
