## A command-line application for managing flutter unity at scale

Use this for managing flutter unity project with large teams.


#### Install.

```shell script
    pub global activate flutter_unity_cli
```

#### Usage.

To bootstrap flutter unity plugin project with setup to your flutter app, use this command.

Your folder should be like this before running the command from root.
Also make sure you are in the same folder level as your flutter application.

```yaml
    root:
      - <flutter app project>
```

```shell script
$ fuw create <flutter app project>
```

Your folder should be like this
```yaml
    root:
      - <flutter app project>
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
