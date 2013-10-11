desc 'Upload all books from spreadsheet to app as unapproved'
task load_from_spreadsheet: :environment do
  Rails.logger.info "Logging in to spreadsheet as #{ENV['GOOGLE_USERNAME']}"
  session = GoogleDrive.login ENV['GOOGLE_USERNAME'], ENV['GOOGLE_PASSWORD']
  ss = session.spreadsheet_by_key(ENV['GOOGLE_SPREADSHEET'])
  Rails.logger.info 'Logged in'

  ss.worksheets.each do |ws|
    category = ws.title
    Rails.logger.info "Reading #{category} worksheet"
    headers = ws.rows[0]
    Rails.logger.info "Headers are #{headers}"
    cols = {}
    %w(title author publisher year condition isbn price consignee consignment genre quantity).each do |col|
      index = headers.index { |h| h.strip.downcase.split(' ')[0] == col }
      key = col.to_sym
      key = :edition if key == :year
      key = :consignment_date if key == :consignment
      key = :price_cents if key == :price
      cols[key] = index if index
    end
    Rails.logger.info "Column keys are #{cols}"
    1.upto ws.num_rows - 1 do |i|
      row = ws.rows[i]
      if row
        quantity = (cols[:quantity] and row[cols[:quantity]].to_i) || 1
        attributes = cols.keys.reject{ |k| k == :quantity }.each_with_object({}) { |key, attr_hash|
          val = row[cols[key]]
          val = case key
            when :price_cents
              v = val && val.gsub(/\D/, '')
              (v.blank?) ? nil : Integer(v) * 100
            when :isbn
              val.strip.gsub /\W/, ''
            when :consignment_date
              if val.present?
                Rails.logger.info "Parsing #{val} as date"
                Date.parse(val) rescue nil
              end
            else
              val
          end
          attr_hash[key] = val if val.present?
        }
        1.upto quantity do
          book = Book.new attributes
          book.save
          Rails.logger.info "Saved Book #{book.inspect}"
        end
      end
    end
  end
end
