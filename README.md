# SieveFiler
`SieveFiler` is a Swift-based DSL to aid in creating Sieve ([RFC 5228](https://www.rfc-editor.org/rfc/rfc5228)) "fileinto" rules for server-side mail sorting.  The primary goal is to make it easier and less error-prone to creating rules for filing mail into specific folders.

## Features
`SieveFiler` will:

* Ensure output sieve rules are ordered from specific to general
* Ensure full email addresses are given for `Addresses()`
* Ensure only domain names are given for `Domains()` and `SubDomains()`
* Ensure conflicting rules are not possible (e.g. cannot specify that the same email address goes to different folders)
* Not overewite the file if any errors are detected

## Requirements

[Swift Compiler 5.7+](https://www.swift.org/download/).  By utilizing the [Swift](https://www.swift.org) language, you can use Xcode or any other IDE/text editor to aid in command completion and online help as  you write your rules.

## Recommended Usage

The simplest usage is to install [swift-sh](https://github.com/mxcl/swift-sh):

```sh
mint install swift-sh
```

Then create your Sieve script like so:

```swift
#!/usr/bin/swift sh
import SieveFiler // @dannys42
import Foundation

try SieveRules {
    Folder("Family") {
        Fields(.from) {
            Domains("myfamily.xyz")  // matches exactly the addresses given
        }
    }
    Folder("Parents") {
        Fields(.from) {
            Addresses("mom@myfamily.xyz", "dad@myfamily.xyz")  // matches exactly the addresses given
        }
    }
    Folder("Classmates") {
        Fields(.from, .replyTo) {
            Domains("myschoolalumnis.edu")  // matches exactly emails that have `myschoolalumnis.edu` after the "@" sign
            SubDomains("myschool.edu")      // matches *.myschool.edu and @myschool.edu
        }
    }
}.output(".dovecot.sieve")

```

This will create rules in the following order:

* Mail from `mom@myfamil.xyz` and `dad@myfamily.xyz` will go into `Parents`
* Mail from anyone else in the `myfamily.xyz` domain will go to `Family`
* Any mail with a `From` or `Reply-To` field with a domain of exactly `myschoolalumnis.edu` will go into `Classmates`
* Any mail with a `From` or `Reply-To` field with a domain or any subdomain of `myschool.edu` will also go into `Classmates`


Additional conveniences:

* `Domains`, `SubDomains`, and `Addresses` can also take array arguments to allow for flexibility in trailing commas.  For example:

```swift
    Folder("Parents") {
        Fields(.from) {
            Addresses([
            	"mom@myfamily.xyz",
            	"dad@myfamily.xyz",
            ])
        }
    }

```


* In cases where only one type of `Fields` matching is needed, you can specify that field on the `Folder()` line.  For example:

```swift
    Folder("Parents", fields: .from) {
        Addresses([
            "mom@myfamily.xyz",
            "dad@myfamily.xyz",
        ])
    }

```

