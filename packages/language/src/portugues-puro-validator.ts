import type { ValidationAcceptor, ValidationChecks } from 'langium';
import type { PortuguesPuroAstType, Person } from './generated/ast.js';
import type { PortuguesPuroServices } from './portugues-puro-module.js';

/**
 * Register custom validation checks.
 */
export function registerValidationChecks(services: PortuguesPuroServices) {
    const registry = services.validation.ValidationRegistry;
    const validator = services.validation.PortuguesPuroValidator;
    const checks: ValidationChecks<PortuguesPuroAstType> = {
        Person: validator.checkPersonStartsWithCapital
    };
    registry.register(checks, validator);
}

/**
 * Implementation of custom validations.
 */
export class PortuguesPuroValidator {

    checkPersonStartsWithCapital(person: Person, accept: ValidationAcceptor): void {
        if (person.name) {
            const firstChar = person.name.substring(0, 1);
            if (firstChar.toUpperCase() !== firstChar) {
                accept('warning', 'Person name should start with a capital.', { node: person, property: 'name' });
            }
        }
    }

}
