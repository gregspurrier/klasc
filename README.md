KLaSC: KLambda Spec Checker
===========================
KLaSC (pronounced "classy") is a compliance test suite for
implementations of KLambda, the kernel Lisp upon which the
(Shen)[http://shenlanguage.org] programming language is implemented.

The specification for KLambda is contained in the
(Official Shen Standard)[http://www.shenlanguage.org/Documentation/shendoc.htm].
Clarifications to the specification may be found on the
(KLambda page)http://shen-wiki.tiodante.com/KLambda] of the
(Shen Wiki)[http://shen-wiki.tiodante.com].

Installing
----------
After cloning the repository, use the following commands to install
KLaSC's dependencies:

    gem install bundler
    bundle install

Running
-------
The current version of KLaSC expects to interact with a Shen REPL. By
default, it assumes that the command to launch a Shen REPL is
+shen+. This can be overridden with the +SHEN_COMMAND+ environment
variable.

KLaSC is implemented with RSpec and does not yet have a wrapper
script. To run it, simply run RSpec:

    bundle exec rspec

Use the +-fs+ argument to RSpec to produce documentation-style output
instead of progress dots.

Disclaimer
----------
The interpretation of the KLambda specification as tested by KLaSC is in
the process of being vetted via discussions on the
(Shen Online News Group)[https://groups.google.com/group/qilang].

All of the tests pass on the Shen-CLisp port, but this does not
necessarily mean that they all reflect required behavior. When in
doubt, consult the news group.

Known Issues
------------
The test driver is only working against Shen-Clisp. Shen-SBCL and
ShenRuby both fail to connect properly. Fixing this is next on the
list of things to do.

Roadmap
-------
The following are the priority for near-term development:

* Support for testing stand-alone KLambda implemenations outside of
  Shen.
  * This is intended primarily to aid KLambda implemenators who do not
    yet have an implemenation that is complete enough to run Shen.
* Adding coverage of the remaining Klambda primitives
* Full vetting and removal of the above disclaimer

License
-------
KLaSC is Copyright (c) 2013 Greg Spurrier. It is released under the
terms of the MIT License. See LICENSE.txt for the details.  
