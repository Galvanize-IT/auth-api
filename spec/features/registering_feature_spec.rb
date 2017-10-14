require "features_helper"

describe "Registering", type: :feature do
  after do
    unstub_auth
  end

  it "allows me to access the system and sign out", js: true do
    stub_auth(uid: "abc123")
    visit(root_path)

    expect(page).to have_link "Sign In", href: "/sign_in"

    click_link "Sign In"

    expect(page).to have_content "Welcome Sterling, you're signed in."
    expect(page).to have_link "Sign Out", href: "/sign_out"

    click_link "Sign Out"

    expect(page).to_not have_content "Sterling"
  end

  it "allows me to sign in when a user is already linked" do
    User.create!(uid: "abc123", first_name: "Malory", last_name: "Archer", email: "malory@isis.com")
    stub_auth(uid: "abc123")
    visit(root_path)

    click_link "Sign In"

    expect(page).to have_content "Welcome Malory, you're signed in."
    expect(page).to have_link "Sign Out", href: "/sign_out"
  end

  it "raises a user resolution error if auth is completely broken for some reason" do
    visit(root_path)

    click_link "Sign In"

    expect(page).to have_link "Sign In", href: "/sign_in"
    expect(page).to have_content "We were unable to find or create a user based on your credentials"
  end

end
