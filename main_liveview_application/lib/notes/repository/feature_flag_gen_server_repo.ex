defmodule Notes.Repository.FeatureFlagGenServerRepo do
  alias Notes.Repository.Protocol.FeatureFlagRepo
  alias Notes.FeatureFlagServer

  defstruct []

  def new() do
    %__MODULE__{}
  end

  defimpl FeatureFlagRepo, for: __MODULE__ do
    alias Notes.Domain.FeatureFlag

    def seed(_) do
      flags = [
        %FeatureFlag{name: :basketball_tutorials, enabled: false},
        %FeatureFlag{name: :dad_jokes, enabled: false}
      ]

      Enum.each(flags, &FeatureFlagServer.add_feature_flag/1)
    end

    def get_all(_) do
      FeatureFlagServer.get_feature_flags()
    end

    def get_enabled(_) do
      FeatureFlagServer.get_enabled_feature_flags()
    end

    def add(_, flag) do
      FeatureFlagServer.add_feature_flag(flag)
    end

    def remove(_, name) do
      FeatureFlagServer.remove_feature_flag(name)
    end

    def toggle(_, name) do
      FeatureFlagServer.toggle_feature_flag(name)
    end
  end
end
