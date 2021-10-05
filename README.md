# .NET program generator

## Description

Tool to create simple C# or PascalABC.NET program.

## Requirements

- Only in Wine:
    - `sed 4.2.1`

## Syntax

```bat
newprogram [options]
```

## Options

- `-h`|`--help` - writes help and exits
- `-v`|`--version` - writes version and exits
- `-l`|`--language` - specifies language name [Available value set is: csharp, pascal.]
- `-p`|`--path` - specifies program path (use `./` to specify current directory)
- `-o`|`--options` - specifies program options with values via space

## Return codes

- `0` - Success
- `2` - Specified option is not supported.
- `2` - Specified language name must be one of: csharp, pascal.
- `2` - Specified path doesn't exist.
- `2` - Specified program already exists or has invalid (tmp.txt) name.

## Examples

```bat
newprogram --help
```

```bat
newprogram --language csharp --path "path/to/program" --options "--help --version"
```
Result:
```cs
using System;
using System.Linq;
using System.Collections.Generic;

internal class Program
{
    public static void Main(string[] args)
    {
        for (var i = 0; i < args.Length; i++)
        {
            string option = args[i];
            string value = i + 1 < args.Length ? args[i + 1] : string.Empty;

            switch (option)
            {
                case "--help": 
                    Help();
                    break;
                case "--version": 
                    Version();
                    break;
                default:
                    Console.Error.WriteLine($"Option {option} is unsupported now.");
                    break;
            }
        }	
    }

    private static void Help()
    {
    }

    private static void Version()
    {
    }
}
```
