require 'spec_helper'

describe AuthApi::Resource::Base do

  let(:json) {
    {
      data: {
        id: '72',
        type: 'users',
        attributes: {
          uid: 'abc12324',
          first_name: 'Sterling',
          last_name: 'Archer',
          email: 'secret.spy23@isis.com',
          unconfirmed_email: 'sterling@isis.com',
          created_at: '2017-06-15T21:34:47.296Z',
          updated_at: '2017-06-15T21:34:47.363Z',
          sign_in_count: 0,
          roles: [],
          data: {
            talent: {key: 'value1', }
          }
        },
        relationships: {
          products: {
            data: [{id: '44', type: 'products'}]
          }
        }
      },
      included: [
        {
          id: '44',
          type: 'products',
          attributes: {
            uid: 'abc1237',
            name: 'Web Development',
            slug: 'web-development',
            title: 'Galvanize Web Development Foundations with JavaScript - Seattle (7.10)',
            product_type: 'Workshop',
            label: '17-01-WD-GT',
            gcode: 'g666WD',
            campus_name: 'Seattle-Pioneer Square',
            slack_channel: 'g666wd-seattle',
            starts_on: '2017-04-20T11:28:43.000Z',
            ends_on: '2017-04-20T11:28:43.000Z'
          }
        }
      ]
    }
  }

  it "can resolve resources with relationships" do
    resource = described_class.resolve_resources(json)
    expect(resource).to be_an_instance_of AuthApi::User
    expect(resource.products[0]).to be_an_instance_of AuthApi::Product
    expect(resource.first_name).to eq 'Sterling'
    expect(resource.products[0].name).to eq 'Web Development'
  end

end
