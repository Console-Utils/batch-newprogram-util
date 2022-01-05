# .NET program generator

## Description

Tool to create simple C# or PascalABC.NET program.

## Syntax

```bat
newprogram [{ -h | --help }] [{ -v | --version }] { -l <value> | --language <value> } { -p <value> | --path <value> } { -o <value> | --options <value> }
```

| Short option | Long option  | Description                                 |
| :----------: | :----------: | :------------------------------------------ |
|     `-h`     |   `--help`   | Print help                                  |
|     `-v`     | `--version`  | Print version                               |
|     `-l`     | `--language` | Specify a language (`csharp`&#124;`pascal`) |
|     `-p`     |   `--path`   | Specify a program output filename           |
|     `-o`     | `--language` | Specify a program option list               |

## Return codes

| Return code | Description                                                    |
| :---------: | :------------------------------------------------------------- |
|     `0`     | Success                                                        |
|     `2`     | Specified option is not supported                              |
|     `2`     | Specified language name must be one of: csharp, pascal         |
|     `2`     | Specified path doesn't exist                                   |
|     `2`     | Specified program already exists or has invalid (tmp.txt) name |

## Supported environments and examples

This info is available only [here](https://console-utils.github.io/).
