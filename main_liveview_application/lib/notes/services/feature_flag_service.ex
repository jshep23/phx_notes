defmodule Notes.Services.FeatureFlagService do
  alias Notes.Repository.Protocol.FeatureFlagRepo

  defp get_repo, do: Application.get_env(:notes, :feature_flag_repo).new()

  def seed do
    get_repo() |> FeatureFlagRepo.seed()
  end

  def get_all do
    get_repo() |> FeatureFlagRepo.get_all()
  end

  def toggle(name) do
    get_repo() |> FeatureFlagRepo.toggle(name)
  end

  def get_enabled do
    get_repo() |> FeatureFlagRepo.get_enabled()
  end
end
