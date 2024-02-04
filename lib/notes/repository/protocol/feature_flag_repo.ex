defprotocol Notes.Repository.Protocol.FeatureFlagRepo do
  def seed(repo)
  def get_all(repo)
  def get_enabled(repo)
  def add(repo, flag)
  def remove(repo, name)
  def toggle(repo, name)
end
