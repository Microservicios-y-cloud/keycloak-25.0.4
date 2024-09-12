<#import "template.ftl" as layout>
<#import "user-profile-commons.ftl" as userProfileCommons>
<#import "register-commons.ftl" as registerCommons>

<@layout.registrationLayout displayMessage=messagesPerField.exists('global') displayRequiredFields=true; section>
    <#if section = "header">
        <#if messageHeader??>
            ${kcSanitize(msg("${messageHeader}"))?no_esc}
        <#else>
            ${msg("registerTitle")}
        </#if>
    <#elseif section = "form">
        <form id="kc-register-form" class="${properties.kcFormClass!}" action="${url.registrationAction}" method="post">

            <@userProfileCommons.userProfileFormFields; callback, attribute>
                <#if callback = "afterField">
                <#-- render password fields just under the username or email (if used as username) -->

                    <#if passwordRequired?? && (attribute.name == 'username' || (attribute.name == 'email' && realm.registrationEmailAsUsername))>
                        <div class="${properties.kcFormGroupClass!}">
                            <div class="${properties.kcLabelWrapperClass!}">
                                <label for="password" class="${properties.kcLabelClass!}">${msg("password")}</label> *
                            </div>
                            <div class="${properties.kcInputWrapperClass!}">
                                <div class="${properties.kcInputGroup!}">
                                    <input type="password" id="password" class="${properties.kcInputClass!}" name="password"
                                           autocomplete="new-password"
                                           aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                                    />
                                    <button class="${properties.kcFormPasswordVisibilityButtonClass!}" type="button" aria-label="${msg('showPassword')}"
                                            aria-controls="password"  data-password-toggle
                                            data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}" data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}"
                                            data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                                        <i class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></i>
                                    </button>
                                </div>

                                <#if messagesPerField.existsError('password')>
                                    <span id="input-error-password" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                                        ${kcSanitize(messagesPerField.get('password'))?no_esc}
                                    </span>
                                </#if>
                            </div>
                        </div>

                        <div class="${properties.kcFormGroupClass!}">
                            <div class="${properties.kcLabelWrapperClass!}">
                                <label for="password-confirm"
                                       class="${properties.kcLabelClass!}">${msg("passwordConfirm")}</label> *
                            </div>
                            <div class="${properties.kcInputWrapperClass!}">
                                <div class="${properties.kcInputGroup!}">
                                    <input type="password" id="password-confirm" class="${properties.kcInputClass!}"
                                           name="password-confirm"
                                           aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
                                    />
                                    <button class="${properties.kcFormPasswordVisibilityButtonClass!}" type="button" aria-label="${msg('showPassword')}"
                                            aria-controls="password-confirm"  data-password-toggle
                                            data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}" data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}"
                                            data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                                        <i class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></i>
                                    </button>
                                </div>

                                <#if messagesPerField.existsError('password-confirm')>
                                    <span id="input-error-password-confirm" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                                        ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                                    </span>
                                </#if>
                            </div>
                        </div>
                    </#if>
                </#if>
            </@userProfileCommons.userProfileFormFields>

            <!-- Aquí es donde agregamos el campo de fecha de nacimiento -->
            <div class="form-group">
                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="user.attributes.dob" class="${properties.kcLabelClass!}">
                    Date of birth</label>
                </div>

                <div class="${properties.kcInputWrapperClass!}">
                    <input type="date" class="${properties.kcInputClass!}" 
                    id="user.attributes.dob" name="user.attributes.dob" 
                    value="${(register.formData['user.attributes.dob']!'')}"/>
                </div>
            </div>

            <!-- Photo URL -->
            <div class="form-group">
                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="user.attributes.photoURL" class="${properties.kcLabelClass!}">
                    Photo URL</label>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="text" class="${properties.kcInputClass!}" 
                    id="user.attributes.photoURL" name="user.attributes.photoURL" 
                    value="${(register.formData['user.attributes.photoURL']!'')}"/>
                </div>
            </div>

            <!-- Description -->
            <div class="form-group">
                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="user.attributes.description" class="${properties.kcLabelClass!}">
                    Description</label>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <textarea class="${properties.kcInputClass!}" id="user.attributes.description" name="user.attributes.description">
                        ${(register.formData['user.attributes.description']!'')}
                    </textarea>
                </div>
            </div>

            <!-- User Type -->
            <div class="form-group">
                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="user.attributes.userType" class="${properties.kcLabelClass!}">User Type</label>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <select id="user.attributes.userType" name="user.attributes.userType" class="${properties.kcInputClass!}" onchange="handleUserTypeChange(this.value)">
                        <option value="customer">Customer</option>
                        <option value="supplier">Supplier</option>
                    </select>
                </div>
            </div>

            <!-- Web URL and Social Media (visible only if Supplier) -->
            <div id="supplier-fields" style="display:none;">
                <!-- Web URL -->
                <div class="form-group">
                    <div class="${properties.kcLabelWrapperClass!}">
                        <label for="user.attributes.webURL" class="${properties.kcLabelClass!}">Web URL</label>
                    </div>
                    <div class="${properties.kcInputWrapperClass!}">
                        <input type="text" class="${properties.kcInputClass!}" 
                        id="user.attributes.webURL" name="user.attributes.webURL" 
                        value="${(register.formData['user.attributes.webURL']!'')}"/>
                    </div>
                </div>

                <!-- Social Media List -->
                <div class="form-group">
                    <div class="${properties.kcLabelWrapperClass!}">
                        <label for="user.attributes.socialMedia" class="${properties.kcLabelClass!}">Social Media</label>
                    </div>
                    <div class="${properties.kcInputWrapperClass!}">
                        <textarea class="${properties.kcInputClass!}" id="user.attributes.socialMedia" name="user.attributes.socialMedia" 
                        placeholder="Enter social media URLs separated by commas">${(register.formData['user.attributes.socialMedia']!'')}</textarea>
                    </div>
                </div>
            </div>

            <@registerCommons.termsAcceptance/>

            <#if recaptchaRequired?? && (recaptchaVisible!false)>
                <div class="form-group">
                    <div class="${properties.kcInputWrapperClass!}">
                        <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}" data-action="${recaptchaAction}"></div>
                    </div>
                </div>
            </#if>

            <div class="${properties.kcFormGroupClass!}">
                <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                    <div class="${properties.kcFormOptionsWrapperClass!}">
                        <span><a href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a></span>
                    </div>
                </div>

                <#if recaptchaRequired?? && !(recaptchaVisible!false)>
                    <script>
                        function onSubmitRecaptcha(token) {
                            document.getElementById("kc-register-form").submit();
                        }
                    </script>
                    <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                        <button class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!} g-recaptcha" 
                            data-sitekey="${recaptchaSiteKey}" data-callback='onSubmitRecaptcha' data-action='${recaptchaAction}' type="submit">
                            ${msg("doRegister")}
                        </button>
                    </div>
                <#else>
                    <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                        <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}" type="submit" value="${msg("doRegister")}"/>
                    </div>
                </#if>
            </div>

        </form>

        <script type="text/javascript">
            function handleUserTypeChange(value) {
                var supplierFields = document.getElementById("supplier-fields");
                if (value === "supplier") {
                    supplierFields.style.display = "block";
                } else {
                    supplierFields.style.display = "none";
                }
            }

            // Initialize visibility based on the current selection
            handleUserTypeChange(document.getElementById("user.attributes.userType").value);
        </script>
    <#elseif section = "footer">
        <!-- Add footer contents if needed -->
    </#if>
</@layout.registrationLayout>
