# Test Kitchen Experiments

This repo contains a few examples of how to test your infrastructure
with [Test Kitchen](http://kitchen.ci/), configuration management tools
like Puppet, and on platforms including docker and AWS EC2.

It's worth adding a warning - I'm learning a number of these tools, and how they
fit together, as I write these examples so please read them carefully and
consider if they make sense either alone or in the context of your environment.
I'm also very happy to receive feedback about other peoples approaches or how
I'm doing something conceptually wrong in the code.

## Examples

The best place to start is with the very simple [strace puppet module
testing with docker](/strace/) example. This can be run on your local
machine and has very few moving parts.

If you're interested in running your tests against a full EC2 instance then the
amazingly named [puppet-simple-aws-ec2](/puppet-simple-aws-ec2/) example will
hopefully be useful.

Testing a manifest against [multiple puppet versions on EC2](/multiple-puppet-versions-aws-
ec2/) is remarkably easy once you've got the basic EC2 tests working. In fact it
only requires changes to two files.

### Author

[Dean Wilson](http://www.unixdaemon.net)
