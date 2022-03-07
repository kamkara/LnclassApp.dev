# config/initializers/bootstrap_form.rb
BootstrapForm.configure do |c|
  c.default_form_attributes = { role: "form" } # to make forms non-compliant with W3C.
end