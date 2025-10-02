json.circles @circles.map do |circle|
  json.partial! 'shared/circle', circle: circle
end
