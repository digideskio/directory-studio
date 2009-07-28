/*
 *  Licensed to the Apache Software Foundation (ASF) under one
 *  or more contributor license agreements.  See the NOTICE file
 *  distributed with this work for additional information
 *  regarding copyright ownership.  The ASF licenses this file
 *  to you under the Apache License, Version 2.0 (the
 *  "License"); you may not use this file except in compliance
 *  with the License.  You may obtain a copy of the License at
 *  
 *    http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License. 
 *  
 */
package org.apache.directory.studio.schemaeditor.view.wizards;


import org.apache.directory.studio.schemaeditor.Activator;
import org.apache.directory.studio.schemaeditor.PluginUtils;
import org.apache.directory.studio.schemaeditor.controller.SchemaHandler;
import org.apache.directory.studio.schemaeditor.model.Project;
import org.apache.directory.studio.schemaeditor.model.Schema;
import org.apache.directory.studio.schemaeditor.view.widget.CoreSchemasSelectionWidget.ServerTypeEnum;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.ui.IImportWizard;
import org.eclipse.ui.IWorkbench;


/**
 * This class represents the wizard to import 'core' schemas into a project.
 *
 * @author <a href="mailto:dev@directory.apache.org">Apache Directory Project</a>
 * @version $Rev$, $Date$
 */
public class ImportCoreSchemasWizard extends Wizard implements IImportWizard
{
    // The pages of the wizard
    private ImportCoreSchemasWizardPage page;


    /* (non-Javadoc)
     * @see org.eclipse.jface.wizard.Wizard#addPages()
     */
    public void addPages()
    {
        // Creating pages
        page = new ImportCoreSchemasWizardPage();

        // Adding pages
        addPage( page );
    }


    /* (non-Javadoc)
     * @see org.eclipse.jface.wizard.Wizard#performFinish()
     */
    public boolean performFinish()
    {
        String[] selectedSchemas = page.getSelectedSchemas();;
        ServerTypeEnum serverType = page.getServerType();

        Project project = Activator.getDefault().getProjectsHandler().getOpenProject();
        if ( project != null )
        {
            if ( ( selectedSchemas != null ) && ( serverType != null ) )
            {
                SchemaHandler schemaHandler = project.getSchemaHandler();
                for ( String selectedSchema : selectedSchemas )
                {
                    Schema schema = PluginUtils.loadCoreSchema( serverType, selectedSchema );
                    if ( schema != null )
                    {
                        schema.setProject( project );
                        schemaHandler.addSchema( schema );
                    }
                }
            }
        }

        return true;
    }


    /* (non-Javadoc)
     * @see org.eclipse.ui.IWorkbenchWizard#init(org.eclipse.ui.IWorkbench, org.eclipse.jface.viewers.IStructuredSelection)
     */
    public void init( IWorkbench workbench, IStructuredSelection selection )
    {
    }
}
