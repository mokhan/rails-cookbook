describe "stronglifters::rails" do
  subject do
    ChefSpec::SoloRunner.new do |node|
      node.set["stronglifters"]["root_path"] = root_path
      node.set["stronglifters"]["username"] = username
      node.set["postgres"]["database"] = "app"
      node.set["postgres"]["username"] = username
      node.set["postgres"]["password"] = "password"
      node.set["postgres"]["host"] = "localhost"
    end.converge(described_recipe)
  end
  let(:root_path) { "/var/www/#{FFaker::Internet.domain_name}"  }
  let(:shared_path) { "#{root_path}/shared" }
  let(:username) { "deployer" }

  before :each do
    stub_command("stat -c %U #{root_path} | grep root").and_return(nil)
  end

  it "creates the root directory for the application" do
    expect(subject).to create_directory(root_path)
  end
end