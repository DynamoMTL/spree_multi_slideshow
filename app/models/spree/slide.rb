module Spree
  class Slide < ActiveRecord::Base
    validate :no_attachment_errors

    belongs_to :slideshow
    belongs_to :slideable, polymorphic: true
    acts_as_list scope: :slideshow

    has_attached_file :attachment,
            :url  => "/spree/slides/:id/:style_:basename.:extension",
            :path => ":rails_root/public/spree/slides/:id/:style_:basename.:extension",
            :styles => { :mini => "60x60#", :small =>  "300x100#", :medium => "600x200#", :large =>  "900x300#"},
            convert_options: { all: '-strip -auto-orient -colorspace sRGB' }

    validates_attachment :attachment,
      :presence => true,
      :content_type => { :content_type => %w(image/jpeg image/jpg image/png image/gif) }

    default_scope { order('position ASC') }

    scope :enable, { conditions: { enabled: true } }

    Spree::Slide.attachment_definitions[:attachment][:styles] = ActiveSupport::JSON.decode(Spree::Config[:slide_styles]).symbolize_keys!
    Spree::Slide.attachment_definitions[:attachment][:path] = Spree::Config[:slide_path]
    Spree::Slide.attachment_definitions[:attachment][:url] = Spree::Config[:slide_url]
    Spree::Slide.attachment_definitions[:attachment][:default_url] = Spree::Config[:slide_default_url]
    Spree::Slide.attachment_definitions[:attachment][:default_style] = Spree::Config[:slide_default_style]

    # if there are errors from the plugin, then add a more meaningful message
    def no_attachment_errors
      unless attachment.errors.empty?
        # uncomment this to get rid of the less-than-useful interrim messages
        # errors.clear
        errors.add :attachment, "Paperclip returned errors for file '#{attachment_file_name}' - check ImageMagick installation or image source file."
        false
      end
    end
  end
end
