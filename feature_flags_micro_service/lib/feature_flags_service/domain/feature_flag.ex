defmodule FeatureFlagsService.Domain.FeatureFlag do
  @derive {Jason.Encoder, only: [:name, :enabled]}
  defstruct [:name, :enabled]
end
