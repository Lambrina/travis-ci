require 'spec_helper'

# TODO does this really belong into the Travis namespace?
describe Travis::GithubApi do
  describe "repositories_for_user" do

    before(:each) do
      @user_repo1 = stub("First User Repo")
      @user_repo2 = stub("Second User Repo")

      @organization1 = stub("Travis Organization", :login => 'travis', :name => 'TravisCI')
      @organization2 = stub("Github Organization", :login => 'github', :name => 'Github')
      # to_ary is needed because of the flatten
      @organization_repo1 = stub("Travis Organization Repo", :to_ary => nil)
      @organization_repo1.stubs(:organization_name=).with("TravisCI")
      @organization_repo2 = stub("Github Organization Repo", :to_ary => nil)
      @organization_repo2.stubs(:organization_name=).with("Github")

      Octokit.stubs(:repositories).with('fulanito').returns([@user_repo1, @user_repo2])
      Octokit.stubs(:organizations).with('fulanito').returns([@organization1, @organization2])
      Octokit.stubs(:organization_repositories).with('travis').returns([@organization_repo1])
      Octokit.stubs(:organization_repositories).with('github').returns([@organization_repo2])
    end

    it "should get the user repositories" do
      Travis::GithubApi.repositories_for_user('fulanito').should include(@user_repo1, @user_repo2)
    end

    it "should never add an organization name to an user repository" do
      @user_repo1.expects(:organization_name).never
      @user_repo1.expects(:organization_name).never
      Travis::GithubApi.repositories_for_user('fulanito')
    end
    
    it "should get the user's organization repositories" do
      Travis::GithubApi.repositories_for_user('fulanito').should include(@organization_repo1, @organization_repo2)
    end

    it "should add an organization name to the repos from organizations" do
      @organization_repo1.expects(:organization_name=).with("TravisCI").once
      @organization_repo2.expects(:organization_name=).with("Github").once
      Travis::GithubApi.repositories_for_user('fulanito')
    end
  end
end


