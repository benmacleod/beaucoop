class DatepickerInput < SimpleForm::Inputs::Base
  def input
    @builder.text_field(attribute_name, input_html_options.merge(class: 'datepicker')).html_safe
  end
end
