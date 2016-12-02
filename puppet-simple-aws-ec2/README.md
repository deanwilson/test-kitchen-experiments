# Puppet AWS EC2 Test-Kitchen Simple Example

This Puppet and [Test-Kitchen](http://kitchen.ci/) example uses Amazon
EC2 to fetch a third-party puppet module from the PuppetForge, use it in
our local module wrapper and then confirm that it did as we expected
with a few [Inspec](http://inspec.io/) tests.

As this test uses AWS it requires both a little more pre-configuration that our
docker examples and may cost you actual money as it creates an EC2 instance to
run our tests on.

## Usage

There are a few things you'll need before you start this experiment.

 * an ssh key pair in AWS with a copy of the private key on the host you'll run
   these tests from.
 * a working `~/.aws/credentials` file.
 * a modern ruby

Clone this repo:

    git clone https://github.com/deanwilson/test-kitchen-experiments.git
    cd test-kitchen-experiments/puppet-simple-aws-ec2

Now we install the `gems` we need.

    bundle install

There are a few values that will almost always vary between users that we need to configure
in our `.kitchen.yml` file. There are three by default and they set via environment variables.

 * `TEST_KITCHEN_EC2_SSH_KEY_ID` the ssh key shown on in the AWS console and the file name
the key is saved as under `~/.ssh`
 * `TEST_KITCHEN_EC2_SECURITY_GROUP_ID` the AWS security group id that allows test kitchen to communicate with your EC2 instance. This should allow inbound SSH
 * `TEST_KITCHEN_EC2_PROFILE` the profile name from `~/.aws/credentials` that contains the creds test kitchen should use.

Once these are set, typically with something like `export TEST_KITCHEN_EC2_PROFILE=ec2-admin` we can check that the basic test-kitchen functionality is working.

    bundle exec kitchen list

Every time this throws an error read the contents of
`.kitchen/logs/kitchen.log` and iterate as required. Now we have all
our requirements in place we'll trigger a full run, up to the verify
stage, with:

    bundle exec kitchen verify default-ubuntu-1404-puppet-3

    -----> Creating <default-ubuntu-1404-puppet-3>...
       Instance <i-e0c2f108> requested.

    ... SNIP LOTS OF TEXT ...

    Target:  ssh://ubuntu@ec2-52-213-189-80.eu-west-1.compute.amazonaws.com:22

      System Package
         ✔  apache2 should be installed
      Service apache2
         ✔  should be running

    Test Summary: 2 successful, 0 failures, 0 skipped
           Finished verifying <default-ubuntu-1404-puppet-3> (0m1.84s).
    -----> Kitchen is finished. (3m26.42s)


Remember to run a destroy when you're finished as AWS will continue to charge
until you do. It's also worth trying to minimise your full `create / verify`
cycles as AWS charges a minimum of an hour every time you create an instance, no
matter how quickly you kill it again.

    bundle exec kitchen destroy default-ubuntu-1404-puppet-3

    -----> Starting Kitchen (v1.14.0)
    -----> Destroying <default-ubuntu-1404-puppet-3>..
           Finished destroying <default-ubuntu-1404-puppet-3> (0m1.05s).
    -----> Kitchen is finished. (0m1.42s)

And again run `bundle exec kitchen list` to see the `Last Action` is now
set to `<Not Created>`.
