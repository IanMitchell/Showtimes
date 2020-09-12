json.status release.staff.includes(:position, :member) do |staff|
  json.position staff.position.name
  json.acronym staff.position.acronym
  json.staff staff.member.name
  json.finished staff.finished
end
