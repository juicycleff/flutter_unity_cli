## A command-line application for managing flutter unity at scale

Use this for managing flutter unity project with large teams.


To create a flutter unity plugin project use this command.

```shell script
$ fuw create flutter_unity_widget
```
or
```shell script
$ fuw create
```

Also make sure you are in the same folder level as your flutter application

Your folder should be like this
```yaml
    root:
      - <fluuter app project>
      - flutter_unity_widget
```

Then add the dependency to your flutter app project
```yaml
    dependencies:
      flutter:
        sdk: flutter
      flutter_unity_widget:
        path: ../flutter_unity_widget

```


To upgrade the plugin to latest version, use
```shell script
$ cd flutter_unity_widget

$ fuw update
```

To upgrade the CLI to latest version, use
```shell script
$ fuw upgrade
```
