module Tach
  class RulesFilter
    def use?(selector, media)
      [media.to_s == 'all',
       selector.start_with?('.'),
       ! selector.include?(':')
      ].all? {|ok| ok }
    end
  end
end