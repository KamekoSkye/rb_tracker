HOSTED_ITEMS =
{
  "brock_beaten",
  "misty_beaten",
  "surge_beaten",
  "erika_beaten",
  "koga_beaten",
  "sabrina_beaten",
  "blaine_beaten",
  "giovanni_beaten",
  "bill",
  "fuji",
  "silphco"
}

function initialize_watch_items()
  for _, code in pairs(HOSTED_ITEMS) do
    ScriptHost:AddWatchForCode(code, code, toggle_item)
    ScriptHost:AddWatchForCode(code.."_hosted", code.."_hosted", toggle_hosted_item)
  end
end