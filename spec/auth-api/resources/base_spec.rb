require "spec_helper"

describe AuthApi::Resource::Base do

  let(:json) do
    {
      data: {
        id: "72",
        type: "users",
        attributes: {
          uid: "abc12324",
          first_name: "Sterling",
          last_name: "Archer",
          email: "secret.spy23@isis.com",
          unconfirmed_email: "sterling@isis.com",
          created_at: "2017-06-15T21:34:47.296Z",
          updated_at: "2017-06-15T21:34:47.363Z",
          sign_in_count: 0,
          roles: [],
          data: {
            talent: { key: "value1" }
          }
        },
        relationships: {
          products: {
            data: [
              { id: "44", type: "products" }
            ]
          },
          identities: {
            data: [
              { id: "666", type: "identities" }
            ]
          },
          favorite_drinks: {
            data: [
              { id: "42", type: "drinks" }
            ]
          }
        }
      },
      included: [
        {
          id: "44",
          type: "products",
          attributes: {
            uid: "abc1237",
            name: "Web Development",
            slug: "web-development",
            title: "Galvanize Web Development Foundations with JavaScript - Seattle (7.10)",
            product_type: "Workshop",
            label: "17-01-WD-GT",
            gcode: "g666WD",
            campus_name: "Seattle-Pioneer Square",
            slack_channel: "g666wd-seattle",
            starts_on: "2017-04-20T11:28:43.000Z",
            ends_on: "2017-04-20T11:28:43.000Z"
          }
        },
        {
          id: "666",
          type: "identities",
          attributes: {
            provider: "github",
            uid: "abc123",
            username: "kravmaga29",
            created_at: "2017-04-20T11:28:43.000Z",
          }
        }
      ],
      meta: {
        event: "user.update",
        changes: {
        }
      }
    }
  end

  it "can resolve resources with relationships" do
    resource = described_class.resolve_resources(json)
    resource.last_name = "SecretAgentMan"
    expect(resource).to be_an_instance_of AuthApi::User
    expect(resource.products[0]).to be_an_instance_of AuthApi::Product
    expect(resource.first_name).to eq "Sterling"
    expect(resource.last_name).to eq "SecretAgentMan"
    expect(resource.email?).to be_truthy
    expect(resource.products[0].name).to eq "Web Development"
    expect(resource.identities[0].username).to eq "kravmaga29"
    expect { resource.unknown_prop }.to raise_error(NoMethodError)
  end

  it "defines empty relationships when they're empty" do
    resource_json = json
    resource_json[:data][:relationships][:products][:data] = nil
    resource = described_class.resolve_resources(json)
    expect(resource).to be_an_instance_of AuthApi::User
    expect(resource.products).to eq []
    expect(resource.registrations).to eq []
  end

  it "exposes the meta event name to the resource" do
    resource = described_class.resolve_resources(json)
    expect(resource.webhook_event).to eq "user.update"
  end

end
