# SieveFiler
A library to aid in creating Sieve "fileinto" rules

Desired target:

 Folder("fjskdfdjslfj") {
    Fields([.from, .replyall]) {
        Domains([ "abc.com" ]) // matches exactly abc.com
        Subdomains([ "def.com" ]) // matches *.def.com and @def.com
        Addresses([ "xyz@123.com" ]) // matches exactly the address given
    }
 }

