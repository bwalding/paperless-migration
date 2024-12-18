

class LookupCache
    attr_reader :id_field
    attr_reader :name_field

    def initialize(name, endpoint, token, id_field, name_field) 
        @name = name
        @endpoint = endpoint
        @id_field = id_field
        @name_field = name_field
        @headers = ({ Authorization: "Token #{token}" })
        self.load()
    end

    def load()
        @data = {}
        puts "Getting #{@endpoint} with #{@headers}"
        url = @endpoint
        while url
            data_json = RestClient::Request.execute(method: :get, url: url, headers: @headers)
            data = JSON.parse(data_json)
            data['results'].each do |d|
                @data[d[name_field]] = d[id_field]
            end
            url = data['next']
        end
        puts "#{@name} => Loaded #{@data.length} items"
        nil
    end

    def find_or_create(name)
        if @data[name].nil?
            new_item_data = RestClient.post(
                @endpoint,
                { name: name },
                @headers
            )
            puts "#{name} => Created new item: #{new_item_data}"
            new_item = JSON.parse(new_item_data)
            new_item_id = new_item["id"]
            @data[name] = new_item["id"]
        end
        @data[name]
    rescue => e
        raise "#{@name} Failure to create new item: #{e}"
    end
    
end