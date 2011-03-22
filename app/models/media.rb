class Media < ActiveRecord::Base
  set_table_name :medias
  include AgeGraphHelper
  include MapGraphHelper

  has_many :media_supports
  has_many :users, :through => :media_supports
  has_many :media_audits
  belongs_to :media_type
  has_many :children, :class_name => 'Media', :foreign_key => "parent_media_id"
  belongs_to :parent_media, :class_name => 'Media'

  define_index do
    indexes :name
    indexes :keywords
  end

  def age_all media_id
    generate_age_all :base_object_name => 'media', :base_object_id => media_id
  end


  def age_state media_id, state
    generate_age_state :base_object_name => 'media', :base_object_id => media_id, :state => state
  end

  def map_all media_id
    generate_map_all :base_object_name => 'media', :base_object_id => media_id
  end

  def map_state media_id, state
    generate_map_state :base_object_name => 'media', :base_object_id => media_id, :state => state
  end

  def translate_media_type media_type_id
    if media_type_id == 3
      return 6 #If Radio, look up records marked as radio show
    elsif media_type_id == 4
      return 5 #If Television, look up records marked as television show
    else
      return media_type_id
    end
  end

  def media_type_age_all media_type_id
    media_type_id = translate_media_type media_type_id

    generate_age_all :base_object_name => 'media', 
      :base_object_id => nil,
      :skip_object_id_filter => true,
      :joins => ['join medias on medias.id = media_supports.media_id'],
      :conditions => [{'medias.media_type_id' => media_type_id}]
  end

  def media_type_age_state media_type_id, state
    media_type_id = translate_media_type media_type_id
    generate_age_state :base_object_name => 'media', 
      :state => state,
      :base_object_id => nil,
      :skip_object_id_filter => true,
      :joins => ['join medias on medias.id = media_supports.media_id'],
      :conditions => [{'medias.media_type_id' => media_type_id}]
  end

  def media_type_map_all media_type_id
    media_type_id = translate_media_type media_type_id
    generate_map_all :base_object_name => 'media', 
      :base_object_id => nil,
      :skip_object_id_filter => true,
      :joins => ['join medias on medias.id = media_supports.media_id'],
      :conditions => [{'medias.media_type_id' => media_type_id}]
  end

  def media_type_map_state media_type_id, state
    media_type_id = translate_media_type media_type_id
    generate_map_state :base_object_name => 'media', 
      :state => state,
      :base_object_id => nil,
      :skip_object_id_filter => true,
      :joins => ['join medias on medias.id = media_supports.media_id'],
      :conditions => [{'medias.media_type_id' => media_type_id}]
  end


  def network_age_all network_id
    generate_age_all :base_object_name => 'media', 
      :base_object_id => nil,
      :skip_object_id_filter => true,
      :joins => ['join medias on medias.id = media_supports.media_id'],
      :conditions => [{'medias.parent_media_id' => network_id}]
  end

  def network_age_state network_id, state
    generate_age_state :base_object_name => 'media', 
      :state => state,
      :base_object_id => nil,
      :skip_object_id_filter => true,
      :joins => ['join medias on medias.id = media_supports.media_id'],
      :conditions => [{'medias.parent_media_id' => network_id}]
  end

  def network_map_all network_id
    generate_map_all :base_object_name => 'media', 
      :base_object_id => nil,
      :skip_object_id_filter => true,
      :joins => ['join medias on medias.id = media_supports.media_id'],
      :conditions => [{'medias.parent_media_id' => network_id}]
  end

  def network_map_state network_id, state
    generate_map_state :base_object_name => 'media', 
      :state => state,
      :base_object_id => nil,
      :skip_object_id_filter => true,
      :joins => ['join medias on medias.id = media_supports.media_id'],
      :conditions => [{'medias.parent_media_id' => network_id}]
  end

  class << self
    def media_lookup id
      begin
        return Media.find id
      rescue
        return nil
      end
    end


    # text - search text
    # media_type_id
    # parent_media_id
    # user_id - user id, if support should be included
    #   vote - if user_id is specified, will filter by thumbs_up, thumbs_down, vote, no_vote, all
    # sort - {sort_name}_{sort_direction}
    # do_search will return an AR object with all that match the specified filter.  
    # It DOES NOT apply paging (limit, offset)
    def do_search(params={})
      records = Media.where('1=1')
      select = ['medias.id as id', 'medias.name as name', 'medias.media_type_id as media_type_id', 'medias.parent_media_id as parent_media_id', 'medias.logo as logo', 'medias.social_score as social_score', 'medias.participation_rate as participation_rate', 'medias.data1', 'medias.data2', 'medias.website as website', 'medias.wikipedia as wikipedia']

      #If the user_id is specified, load the vote data
      if params.key? :user_id
        select << 'media_supports.support_type as support_type'
        records = records.joins("LEFT OUTER JOIN media_supports ON medias.id=media_supports.media_id AND user_id=#{params[:user_id].to_i}")
      end

      #Only apply text filter or thumbs up/thumbs down filter
      if params.key? :text
        #Get a list of media ids that match the search text
        records_to_include = Media.search params[:text].strip, :star => true, :max_matches => 50
        media_ids = records_to_include.inject([]) do |r, element|
          r << element.id
          r
        end
        records = records.where("medias.id in (?)", media_ids)
      elsif params.key? :vote
        case params[:vote].strip.upcase
        when "THUMBSUP"
          records = records.where("support_type = 1")
        when "THUMBSDOWN"
          records = records.where("support_type = 0")
        when "NEUTRAL"
          records = records.where("support_type = 2")
        when "VOTE"
          records = records.where("support_type >= 0")
        when "NOVOTE"
          records = records.where("support_type IS NULL OR support_type = -1")
        end
      end

      if params.key? :parent_media_id
        records = records.where("parent_media_id = ?", params[:parent_media_id].to_i)
      end

      if params.key? :media_type_id
        records = records.where("media_type_id = ?", params[:media_type_id].to_i)
      end


      if params.key? :social_score
        records = records.where("social_score >= ?", params[:social_score].to_i)
      end

      if params.key? :participation_rate
        records = records.where("participation_rate >= ?", params[:participation_rate].to_i)
      end

      records = records.select(select.join(", "))

      if params.key? :sort
        case params[:sort].downcase
        when 'name_asc'
          records = records.order('medias.name asc')
        when 'name_desc'
          records = records.order('medias.name desc')
        when 'social_asc'
          records = records.order('medias.social_score asc')
        when 'social_desc'
          records = records.order('medias.social_score desc')
        when 'participation_asc'
          records = records.order('medias.participation_rate asc')
        when 'participation_desc'
          records = records.order('medias.participation_rate desc')
        when 'votedate_asc'
          if params.key? :user_id
            records = records.order('media_supports.updated_at asc')
          end
        when 'votedate_desc'
          if params.key? :user_id
            records = records.order('media_supports.updated_at desc')
          end
        when 'default_asc'
          records = records.order('medias.default_order asc')
        when 'default_desc'
          records = records.order('medias.default_order desc')
        else
          records = records.order('medias.name asc')
        end
      end
      return records
    end
  end
end
