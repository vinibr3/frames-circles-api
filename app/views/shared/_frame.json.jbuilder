json.id frame.id
json.x frame.x.to_f
json.y frame.y.to_f
json.width frame.width.to_f
json.height frame.height.to_f
json.geometry frame.geometry
json.circles_count frame.circles_count
json.created_at frame.created_at
json.updated_at frame.updated_at

json.highest_circle do
  json.partial! 'shared/circle', circle: frame.highest_circle if frame.highest_circle
end

json.lowest_circle do
  json.partial! 'shared/circle', circle: frame.lowest_circle if frame.lowest_circle
end

json.rightest_circle do
  json.partial! 'shared/circle', circle: frame.rightest_circle if frame.rightest_circle
end

json.leftest_circle do
  json.partial! 'shared/circle', circle: frame.leftest_circle if frame.leftest_circle
end
