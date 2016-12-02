# verify that the apache module did as it is supposed to
describe package('apache2') do
  it { should be_installed }
end

describe service('apache2') do
  it { should be_running }
end

