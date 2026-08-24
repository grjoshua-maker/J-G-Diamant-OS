-- Invoice status changes were producing overlapping customer notifications through
-- invoices_notify_customer and trg_notify_invoice_status. Keep the richer canonical
-- status notifier (sent / due / paid) and remove the older overlapping trigger.
drop trigger if exists invoices_notify_customer on public.invoices;
