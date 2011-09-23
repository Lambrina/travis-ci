require 'spec_helper'

# TODO does this really belong into the Travis namespace?
describe Travis::GithubApi do
  describe "repositories_for_user" do
    it "should get the user repositories" do
      repo1 = stub()
      repo2 = stub()
      
      Octokit.stubs(:repositories).with('fulanito').returns([repo1, repo2])
      Octokit.stubs(:organizations).with('fulanito').returns([])
      
      Travis::GithubApi.repositories_for_user('fulanito').should include(repo1, repo2)
    end
    
    it "should get the user's organization repositories" do
      organization1 = stub(:login => 'travis')
      organization2 = stub(:login => 'github')
      repo1 = stub(:to_ary => nil)
      repo2 = stub(:to_ary => nil)
      
      Octokit.stubs(:repositories).with('fulanito').returns([])
      Octokit.stubs(:organizations).with('fulanito').returns([organization1, organization2])
      Octokit.stubs(:organization_repositories).with('travis').returns([repo1])
      Octokit.stubs(:organization_repositories).with('github').returns([repo2])
      
      Travis::GithubApi.repositories_for_user('fulanito').should include(repo1, repo2)
    end
  end
end


