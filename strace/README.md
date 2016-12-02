# Puppet Test-Kitchen Simple Example

This is the simplest end-to-end [Test-Kitchen](http://kitchen.ci/)
example I could write in Puppet. It uses Puppet, Docker and Inspec to ensure
the strace package is installed.

While this is completely naive in its simplicity it does help validate
all the steps on your local deployment.

## Usage

Before you start you should ensure that docker is installed and running and you
have a local, modern, ruby.

Clone this repo:

    git clone https://github.com/deanwilson/test-kitchen-experiments.git
    cd test-kitchen-experiments/strace

Now we install the `gems` we need.

    bundle install

Once the gems are installed test that Test-Kitchen works

    bundle exec kitchen list

Every time this throws an error read the contents of `.kitchen/logs/kitchen.log`
and iterate as required. Now we have all our requirements in place we'll step
through a test run piece by piece. First we'll create the instance our tests
will use.

    bundle exec kitchen create default-ubuntu-1404

    -----> Starting Kitchen (v1.14.0)
    -----> Creating <default-ubuntu-1404>...
       Sending build context to Docker daemon 22.02 kB
              Step 1 : FROM ubuntu:14.04
    ....

When this command finishes check everything was successful

    bundle exec kitchen list
    Instance             Driver  Provisioner  Verifier  Transport  Last Action  Last Error
    default-ubuntu-1404  Docker  PuppetApply  Inspec    Ssh        Created <None>

Now we'll run the `converge` stage. The most important part of this step is that
it runs our puppet code on the instance.

    bundle exec kitchen converge default-ubuntu-1404

    Notice: Compiled catalog for b0c13f880c71.udlabs.priv in environment
    production in 0.09 seconds
    Notice: /Stage[main]/Strace/Package[strace]/ensure: ensure changed 'purged' to 'present'
    Notice: Finished catalog run in 10.80 seconds
    Finished converging <default-ubuntu-1404> (1m31.69s).

You can rerun `bundle exec kitchen list` to double check the instance has
changed state. Now we get to our original purpose, running the actual tests.


    bundle exec kitchen verify default-ubuntu-1404

    -----> Starting Kitchen (v1.14.0)
    -----> Verifying <default-ubuntu-1404>...
           Using `/my/path/modules/strace/test/integration/default` for testing

    Target:  ssh://kitchen@localhost:32768

         System Package
              ✔  strace should be installed

    Test Summary: 1 successful, 0 failures, 0 skipped
           Finished verifying <default-ubuntu-1404> (0m0.18s).
    -----> Kitchen is finished. (0m0.55s)

All our tests are passing and green so we'll tidy up and remove the instance.

    bundle exec kitchen destroy default-ubuntu-1404

    -----> Starting Kitchen (v1.14.0)
    -----> Destroying <default-ubuntu-1404>..
           Finished destroying <default-ubuntu-1404> (0m1.05s).
    -----> Kitchen is finished. (0m1.42s)

And again run `bundle exec kitchen list` to see the `Last Action` is now
set to `<Not Created>`.

If you want to run a full create, converge and test in a single command run
`bundle exec kitchen verify default-ubuntu-1404`. It will perform all the same
steps we manually ran above and leave the instance in place.
