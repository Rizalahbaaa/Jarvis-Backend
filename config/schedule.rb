every 1.minutes do
    runner UserNote.delete_expired_invitations
  end