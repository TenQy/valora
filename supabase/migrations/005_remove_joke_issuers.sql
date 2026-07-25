-- Remove joke issuer "gugul" that was transferred during the initial catalog population
delete from certifications where issuer ilike 'gugul';
delete from certification_issuers where name ilike 'gugul';
