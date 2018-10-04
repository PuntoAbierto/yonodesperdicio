# encoding : utf-8
module AdHelper

  def self.get_users_ranking(limit=20)
    User.order("ads_count DESC").select('username, ads_count, id').limit(limit)
  end

  def self.get_locations_ranking(limit=20)
    Ad.give.group_by(&:woeid_code).
       map{ |w,a| [WoeidHelper.convert_woeid_name(w)[:full], w, a.count] }.
       sort_by{|k| k[2]}.reverse.take(limit) 
  end

  def formated_date(date)
     date.strftime("%d-%m-%Y") if date
  end

  def great_total_quantity
    grams = Ad.give.delivered.sum(:grams)
    grams_to_kg(grams)
  end

  def grams_to_kg(grams)
  	if grams > 0
  	  grams / 1000.0
  	else
  	  grams
  	end
  end
end
