# SieveFiler
`SieveFiler` is a Swift-based DSL to aid in creating Sieve "fileinto" rules.  The primary goal is to make it easier and less error-prone to creating rules for filing mail into specific folders.

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

let rules = SieveRules {
    Folder("Family") {
        Fields(.from, .replyTo) {
            Addresses("mom@myfamily.xyz") // matches exactly the address given
        }
    }
    Folder("Classmates") {
        Fields(.from, .replyTo) {
            Domains("myschoolalumnis.edu")  // matches exactly emails that have `myschoolalumnis.edu` after the "@" sign
            SubDomains("myschool.edu")    // matches *.myschool.edu and @myschool.edu
        }
    }
}
try rules.validate()
rules.output(".dovecot.sieve")

```
