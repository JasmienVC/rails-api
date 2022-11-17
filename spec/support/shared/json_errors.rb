require 'rails_helper'

shared_examples_for "unauthorized_requests" do
  let(:authentication_error) do
    {
      status:  "401",
      source:  { pointer: "/code" },
      title: "Invalid authentication code",
      detail: "You must provide valid code in order to exchange it for token."
    }
  end

  it 'should return 401 status' do
    subject
    expect(response).to have_http_status(401)
  end

  it 'should return proper error body' do
    subject
    expect(json[:errors]).to include(authentication_error)
  end
end

shared_examples_for 'forbidden_requests' do
  let(:forbidden_error) do
    {
      status:  "403",
      source:  { pointer: "/headers/authorization" },
      title: "Not authorized",
      detail: "You have not right to access this resource."
    }
  end

  it 'should return 403 status code' do
    subject
    expect(response).to have_http_status(:forbidden)
  end

  it 'should return proper error json' do
    subject
    expect(json[:errors]).to include(forbidden_error)
  end
end
