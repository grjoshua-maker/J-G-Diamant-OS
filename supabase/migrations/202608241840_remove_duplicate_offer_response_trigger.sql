-- Two response triggers were applying the same customer decision to an offer.
-- Keep trg_sync_offer_response as the canonical workflow because it also synchronizes
-- project/request state and creates customer/admin notifications.
drop trigger if exists offer_response_apply on public.offer_responses;
