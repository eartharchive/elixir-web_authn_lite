defmodule WebAuthnLite.Operation.Register do
  @moduledoc """
  Functions for Registering a new credential operation

  https://www.w3.org/TR/webauthn/#registering-a-new-credential
  """

  alias WebAuthnLite.{ClientDataJSON, AttestationObject}

  @registration_type "webauthn.create"

  @rounded_error {:error, :invalid_client_data_json}

  @doc """
  Verify clientDataJSON and return struct.

  iex> {:ok, client_data_json} = WebAuthnLite.Operation.Register.validate_client_data_json(%{client_data_json: encoded_client_data_json, origin: origin, challenge: challenge})
  """
  @spec validate_client_data_json(params :: map) ::
          {:ok, client_data_json :: ClientDataJSON.t()} | {:error, term}
  def validate_client_data_json(%{
        client_data_json: encoded_client_data_json,
        origin: origin,
        challenge: challenge
      }) do
    case ClientDataJSON.validate(encoded_client_data_json, @registration_type, origin, challenge) do
      {:ok, _client_data_json} = valid -> valid
      {:error, _} = invalid -> invalid
      _ -> @rounded_error
    end
  end

  @doc """
  Verify attestation object and return public key.

  # NOTE: This function doesn't verify attestation statement yet.

  iex> {:ok, attestation_object} = WebAuthnLite.Operation.Register.validate_attestation_object(%{attestation_object: encoded_attestation_object, client_data_json: encoded_client_data_json})
  """
  @spec validate_attestation_object(params :: map) ::
          {:ok, attestation_object :: AttestationObject.t()} | {:error, term}
  def validate_attestation_object(%{
        attestation_object: encoded_attestation_object,
        client_data_json: _client_data_json
      }) do
    case AttestationObject.decode(encoded_attestation_object) do
      {:ok, _attestation_object} = valid -> valid
      error -> error
    end
  end
end
