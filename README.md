# SieveFiler
`SieveFiler` is a Swift-based DSL to aid in creating Sieve "fileinto" rules.  The primary goal is to make it easier and less error-prone to creating rules for filing mail into specific folders.

## Features
`SieveFiler` will:

* Ensure output sieve rules are ordered from specific to general
* Ensure full email addresses are given for `Addresses()`
* Ensure only domain names are given for `Domains()` and `SubDomains()`
* Not overewite the file if any errors are detected


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