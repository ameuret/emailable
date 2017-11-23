require 'emailable/version'
require 'resolv'
require 'net/telnet'
require 'pp'

module Emailable
  def self.true?(receiver, sender)
    c = Emailable::Checker.new sender
    r = c.emailable? receiver
    c.close
    r
  end

  class Checker

    EMAIL_REGEXP = /^([^@\s]+)@([^@\s]+\.[^@\s]+)$/
    
    def initialize(sender)
      raise ArgumentError "sender argument must be an e-mail address" unless sender.match EMAIL_REGEXP
      @sender = sender.dup
      @resolver = Resolv::DNS.new nameserver: '8.8.8.8'
      @debug = false
    end

    def valid_email? addr
      addr.match EMAIL_REGEXP
    end

    def emailable?(receiver)
      raise ArgumentError unless receiver.match EMAIL_REGEXP
      recDomain = $2
      begin
        exchName = @resolver.getresource(recDomain, Resolv::DNS::Resource::IN::MX).exchange.to_s
        check(receiver, exchName)
      rescue Resolv::ResolvError
        raise RuntimeError
      end
    end

    def check(receiver, exchName)
      @sender.match EMAIL_REGEXP
      domain = $2      
      begin
#        exchName = 'gmail-smtp-in.l.google.com'
        @smtp = Net::Telnet::new("Host" => exchName, "Port" => 25, "Telnetmode" => false)
        @smtp.waitfor('Match'=> /220/) {|r| STDERR.puts "<#{r.to_s.dump}>" if @debug}
        request("EHLO #{domain}", /250 /)
        request("MAIL FROM: <#{@sender}>", /250 /)
        request("RCPT TO: <#{receiver}>", /250 /)
        @smtp.cmd "QUIT"
      rescue Net::ReadTimeout
        return false
      end
      true
    end

    def close
      @smtp.close if @smtp
    end

    private

    def request(cmd, expected)
      STDERR.puts ">#{cmd.dump}" if @debug
      @smtp.puts cmd
      @smtp.waitfor(
        'Match'=> expected,
        'Timeout'=> 0.5,
      ) {|r| STDERR.puts "<#{r.to_s.dump}>" if @debug}
    end
  end
end
