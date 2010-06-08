module Smartphone
  module RequestWithSphone
    # 環境変数 HTTP_USER_AGENT を返す。
    def user_agent
      env['HTTP_USER_AGENT']
    end

    # for reverse proxy.
    def remote_addr
      if respond_to? :remote_ip
        return __send__(:remote_ip)
      else
        return ( env["HTTP_X_FORWARDED_FOR"] ? env["HTTP_X_FORWARDED_FOR"].split(',').pop : env["REMOTE_ADDR"] )
      end
    end

    # 環境変数 HTTP_USER_AGENT を設定する。
    def user_agent=(str)
      self.env["HTTP_USER_AGENT"] = str
    end

    def sphone?
      sphone != nil
    end

    def sphone
      return @__sphone if @__sphone

      Smartphone::Sphone.sphones.each do |const|
        c = Smartphone::Sphone.const_get(const)
        return @__sphone = c.new(self) if c::USER_AGENT_REGEXP && user_agent =~ c::USER_AGENT_REGEXP
      end
      nil
    end
  end
end

