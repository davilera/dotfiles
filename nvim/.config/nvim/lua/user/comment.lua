local status_ok, comment = pcall( require, 'Comment' )
if not status_ok then
	return
end

local has_ts_context, ts_context = pcall( require, 'ts_context_commentstring.integrations.comment_nvim' )
if not has_ts_context then
	return
end

comment.setup {
	pre_hook = ts_context.create_pre_hook(),
}
